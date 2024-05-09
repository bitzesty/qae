$.fn.charcount = function() {
  // Fixes label offset
  if ($(this).prev().is("label")) {
    $(this).prev().addClass("char-count-label");
  }

  // Adds class to parent so that we can position the question and input closer
  var prevElement = this.closest(".govuk-form-group").prev();
  if (prevElement.hasClass("clear")) {
    prevElement = prevElement.prev();
  }
  prevElement.addClass("char-spacing");
  if (prevElement.hasClass(".govuk-error-message")) {
    if (prevElement.prev().find(".char-space").size() <= 0) {
      prevElement.prev().append("<span class='char-space'></div>");
    }
  }

  // Creates the character count elements
  this.wrap("<div class='char-count'></div>");
  this.after("<div class='char-text govuk-hint'>Word count: <span class='current-count'>0</span></div>");

  // Includes character limit if there is one
  this.each(function(){
    var maxlength = parseInt($(this).attr("data-word-max"), 10);
    if (maxlength) {
      // hard limit to word count
      var maxlengthlimit = maxlength * 0.1;
      if (maxlengthlimit < 5) {
        maxlengthlimit = 5;
      }
      // Strict limit with no extra words
      if ($(this).closest(".word-max-strict").size() > 0) {
        maxlengthlimit = 0;
      }
      $(this).attr("data-word-max-limit", (maxlengthlimit));
    }
  });

  // If character count is over the limit then show error
  var characterOver = function(counter, textInput) {
    var lastLetter = textInput.val()[textInput.val().length - 1];
    var maxWordCount = parseInt(textInput.attr("data-word-max"), 10);
    var maxWordCountLimit = parseInt(textInput.attr("data-word-max-limit"), 10);
    var maxWordCountTotal = maxWordCount + maxWordCountLimit;

    textInput.closest(".char-count").removeClass("char-over");
    if (counter.words >= maxWordCount) {
      textInput.closest(".char-count").addClass("char-over");
    }

    if (counter.words > maxWordCountTotal) {
      return true;
    } else if (counter.words == maxWordCountTotal && lastLetter == " ") {
      return true;
    }
  };

  var cutOverChar = function(counter) {
    var textInput = $(this);
    var oldText = $(this).val();
    var newText = "";
    var wordMax = parseInt(textInput.attr("data-word-max"), 10);
    var wordMaxLimit = parseInt(textInput.attr("data-word-max-limit"), 10);
    var wordTotal = wordMax + wordMaxLimit;

    if (counter.words > wordTotal) {
      var oldTextArray = oldText.split(" ");
      var lastIndexOf = oldTextArray.length - 1;
      if (oldTextArray[oldTextArray.length - 1] === "") {
        lastIndexOf = oldTextArray.length - 2;
      }
      var lastIndex = oldText.split(" ", lastIndexOf).join(" ").length;
      if (oldText.lastIndexOf("\n") + 1 > lastIndex) {
        lastIndex = oldText.lastIndexOf("\n") + 1;
      }
      newText = oldText.substr(0, lastIndex) + " ";
      newText = newText.replace(/\s+$/g, "");

      $(this).closest(".char-count").find(".char-text .current-count").text(wordTotal);
    } else {
      $(this).removeClass("char-over-cut");
      newText = oldText;
    }

    if (newText[newText.length - 1] == " " && newText[newText.length - 2] == " ") {
      newText = $.trim(newText) + " ";
    }

    $(this).val(newText);
  };

  var counting = function(counter) {
    var textInput = $(this);

    textInput.closest(".char-count").find(".char-text .current-count").text(counter.words);

    if (characterOver(counter, textInput)) {
      // hard limit to word count using maxlength
      if (((typeof(textInput.attr("maxlength")) !== typeof(undefined)) && textInput.attr("maxlength") !== false) === false) {
        // Set through typing
        var char_limit = textInput.val().length;
        textInput.attr("maxlength", char_limit);
        textInput.addClass("maxlength-reached");
      }
    } else {
      textInput.removeAttr("maxlength");
      textInput.removeClass("maxlength-reached");
    }

    // Locks typing out when the max is reached
    var allowed_keys = [
      8, // backspace key
      46, // delete key
      37, 38, 39, 40, //directional keys
      33, 34, 35, 36, // page jump keys
      9, // tab key
      16, // shift key
      18, // alt key
      112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, // function keys
      27 // escape key
    ];
    var allowed_option_keys = [
      17, // control key
      91, // mac key
    ];
    // Checks if the option key is down
    window.option_key_down = [];
    textInput.on("keydown", function (e) {
      for (var k=0; k<allowed_option_keys.length; k++) {
        if (e.keyCode == allowed_option_keys[k]) {
          if ($.inArray(allowed_option_keys[k], window.option_key_down) < 0) {
            window.option_key_down.push(allowed_option_keys[k]);
          }
        }
      }
    });
    // Checks if the option key is up
    textInput.on("keyup", function (e) {
      for (var k=0; k<allowed_option_keys.length; k++) {
        if (e.keyCode == allowed_option_keys[k]) {
          if ($.inArray(allowed_option_keys[k], window.option_key_down) > -1) {
            window.option_key_down.splice(window.option_key_down.indexOf(allowed_option_keys[k]), 1);
          }
        }
      }
    });
    textInput.on("keydown keyup", function (e) {
      if (textInput.hasClass("maxlength-reached")) {
        var key_allowed = false;

        // Allows some keys like delete
        for (var k=0; k<allowed_keys.length; k++) {
          if (e.keyCode == allowed_keys[k]) {
            key_allowed = true;
          }
        }

        // Allows option key combinations like refreshing the page
        if (window.option_key_down.length > 0) {
          key_allowed = true;
        }

        // Prevents keys that add characters
        if (!key_allowed) {
          e.preventDefault();
        }
      }
    });
  };

  var countText = function(counter) {
    $(this).attr("data-counted-words", counter.words);
  };

  // When a paste event happens, it waits a bit and then triggers the over word count
  // If it isn't over, great, if it is then it cuts it down
  $(this).on("paste", function (e) {
    var textInput = $(this);

    setTimeout(function() {
      textInput.addClass("char-over-cut");
      while (textInput.hasClass("char-over-cut")) {
        Countable.on(textInput[0], cutOverChar);
      }
    }, 100);
  });

  this.each(function() {
    // Makes word count dynamic
    Countable.count(this, counting);

    // Count words even if you backspace/delete
    $(this).on("keydown keyup", function (e) {
      if (e.keyCode == 8 || e.keyCode == 46) {
        Countable.on($(this)[0], counting);
      }
    });
  });

  return this;
};

// Gets character limit and allows no more
$(function() {
  // Creates the character count elements
  $(".js-char-count").charcount();
});


$.fn.removeCharcountElements = function() {
  // Removes the character count elements
  $(this).unwrap();
  $(".char-text, .char-text-limit", $(this).closest("li")).remove();
};
