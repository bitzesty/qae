(function() {
  "use strict"
  var root = this,
      $ = root.jQuery;

  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var PasswordStrengthIndicator = function(options) {
    var instance = this;

    $.each([options["password_field"], options["password_confirmation_field"], options["email_field"]], function(i, password_field) {
      var update = function() {
        var password = $(options["password_field"]).val(),
            passwordConfirmation = $(options["password_confirmation_field"]).val();

        if (typeof options["email_field"] === "object") {
          options["weak_words"] = options["email_field"].val().split(/\W+/);
        } else {
         options["weak_words"] = options["email_field"].split(/\W+/);
        }

        instance.updateIndicator(password, passwordConfirmation, options);
      };

      if ($(password_field).is("input")) {
        $(password_field).debounce("keyup", update, 50);
      }
    });

    $(options["password_strength_guidance"]).attr("aria-live", "polite").attr("aria-atomic", "true");
  };

  PasswordStrengthIndicator.prototype.updateIndicator = function(password, passwordConfirmation, options) {
    var guidance = [];
    var result = zxcvbn(password, options["weak_words"]);
    if (password.length > 0) {
      if (options["min_password_length"] && password.length < parseInt(options["min_password_length"])) {
        guidance.push('password-too-short');
      }

      var isPasswordNotStrongEnough = (result.score < options["strong_passphrase_boundary"]);

      var aWeakWordFoundInPassword = $(options["weak_words"]).is(function(i, weak_word) {
        return (password.indexOf(weak_word) >= 0);
      });
      if (isPasswordNotStrongEnough && aWeakWordFoundInPassword) {
        if (options["weak_words"].join("") !== "") {
          guidance.push("parts-of-email");
        }
      }

      if (isPasswordNotStrongEnough) {
        guidance.push('not-strong-enough');
      } else {
        guidance.push('good-password');
      }
    }

    if (passwordConfirmation.length > 0) {
      if (password === passwordConfirmation) {
        guidance.push("confirmation-matching");
      } else {
        guidance.push("confirmation-not-matching");
      }
    } else {
      guidance.push("no-password-confirmation-provided");
    }

    options["update_indicator"](guidance, result.score);
  };

  GOVUK.passwordStrengthPossibleGuidance = [
    'password-too-short',
    'parts-of-email',
    'not-strong-enough',
    'good-password'
  ]

  GOVUK.passwordConfirmationPossibleGuidance = [
    'confirmation-matching',
    'confirmation-not-matching',
    'no-password-confirmation-provided'
  ]

  GOVUK.passwordStrengthIndicator = PasswordStrengthIndicator;
}).call(this);

$(function() {
  $("form #password-control-group input[type=password]").each(function(){
    var $passwordChangePanel = $('#password-change-panel');
    $('#password-guidance').addClass("govuk-!-display-none");

    var $passwordField = $(this);
    var $passwordConfirmationField = $("form #password-confirmation-control-group input[type=password]");
    var $emailField = "";
    if ($("form #email-control-group input[type=email]").length > 0) {
      $emailField = $("form #email-control-group input[type=email]");
    } else if ($("[data-email-field]").length > 0) {
      $emailField = $("[data-email-field]").attr("data-email-field").split(/\W+/).join(" ");
    }
    $passwordField.parent().parent().prepend('<input type="hidden" class="password-strength-score" name="password-strength-score" value=""/>');

    new GOVUK.passwordStrengthIndicator({
      password_field: $passwordField,
      password_strength_guidance: $('#password-guidance'),
      password_confirmation_field: $passwordConfirmationField,
      password_confirmation_guidance: $('#password-confirmation-guidance'),
      email_field: $emailField,

      strong_passphrase_boundary: 3,
      min_password_length: $passwordField.data('min-password-length'),

      update_indicator: function(guidance, strengthScore) {
        $('.password-strength-score').val(strengthScore);

        var someProblem = false;

        if (guidance.indexOf('password-too-short') !== -1) {
          $('#password-guidance #password-too-short').removeClass("govuk-!-display-none")
          someProblem = true;
        } else {
          $('#password-guidance #password-too-short').addClass("govuk-!-display-none")
        }

        if (guidance.indexOf('parts-of-email') !== -1) {
          $('#password-guidance #parts-of-email').removeClass("govuk-!-display-none")
          someProblem = true;
        } else {
          $('#password-guidance #parts-of-email').addClass("govuk-!-display-none")
        }

        if (guidance.indexOf('not-strong-enough') !== -1) {
          $('#password-guidance #password-entropy').removeClass("govuk-!-display-none")
          someProblem = true;
        } else {
          $('#password-guidance #password-entropy').addClass("govuk-!-display-none")
        }

        if (someProblem) {
          $('#password-guidance').removeClass("govuk-!-display-none");
          $('#password-result-span').addClass("visuallyhidden")
        } else {
          $('#password-guidance').addClass("govuk-!-display-none");
        }

        $passwordChangePanel.removeClass(GOVUK.passwordStrengthPossibleGuidance.join(" "));
        $passwordChangePanel.addClass(guidance.join(" "));

        if ($passwordField.val().length == 0) {
          $passwordField.attr('aria-invalid', "true");
          $('#password-result-span').addClass("visuallyhidden")
        } else if ($.inArray('good-password', guidance) >= 0) {
          $passwordField.attr('aria-invalid', "false");
          $('#password-result-span').removeClass("visuallyhidden")
        } else {
          $passwordField.attr('aria-invalid', "true");
        }

        $passwordChangePanel.removeClass(GOVUK.passwordConfirmationPossibleGuidance.join(" "));
        $passwordChangePanel.addClass(guidance.join(" "));

        var indicator = $('#password-confirmation-result');

        if ($passwordConfirmationField.val().length == 0) {
          $passwordConfirmationField.attr('aria-invalid', "true");
          $('#password-confirmation-result-span').addClass("visuallyhidden")
        } else if ($.inArray('confirmation-not-matching', guidance) >= 0) {
          $passwordConfirmationField.attr('aria-invalid', "true");
          indicator.parent().removeClass('confirmation-matching');
          $('#password-confirmation-result-span').addClass("visuallyhidden")
        } else if ($.inArray('confirmation-matching', guidance) >= 0) {
          $passwordConfirmationField.attr('aria-invalid', "false");
          if($.inArray('good-password', guidance) >= 0) {
            indicator.parent().addClass('confirmation-matching');
            $('#password-confirmation-result-span').removeClass("visuallyhidden")
          }
        }
      }
    });
  });
});
