// Gets character limit and allows no more
$(function() {
  // Creates the character count elements
  $(".js-char-count").wrap("<div class='char-count'></div>")
  $(".js-char-count").after("<div class='char-text'>Character count: <span class='current-count'>0</span></div>");

  // Includes charact limit if there is one
  $(".js-char-count").each(function(){
    var maxlength = $(this).attr('maxlength');
    if (maxlength) {
      $(this).closest(".char-count").find(".char-text").append("/<span class='total-count'>" +maxlength+ "</span>")
    }
  });

  countChar = function (textInput) {
    // Webkit counts a new line as a two characters
    // IE doesn't use maxlength
    var newline = "  ";

    if (navigator.userAgent.toLowerCase().indexOf('firefox') > -1) {
      // Firefox counts a new line as a singular character
      newline = " ";
    }

    content = textInput.val().replace(/(\r\n|\n|\r)/gm, newline);
    textInput.closest(".char-count").find(".char-text .current-count").text(content.length);

    // If character count is over the limit then show error
    if (content.length > textInput.attr('maxlength')) {
      textInput.closest(".char-count").addClass("char-over");
    } else {
      textInput.closest(".char-count").removeClass("char-over");
    }
  }

  // On load, gets character count
  $(".js-char-count").each(function() {
    countChar($(this));
  });

  // On keydown, gets character count
  $(".js-char-count").on('keyup', function () {
    countChar($(this));
  });
});
