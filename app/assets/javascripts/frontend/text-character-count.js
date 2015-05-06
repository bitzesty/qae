$.fn.charcount = function() {
  // Fixes label offset
  if ($(this).prev().is("label")) {
    $(this).prev().addClass("char-count-label");
  }

  // Adds class to parent so that we can position the question and input closer
  var prevElement = this.closest(".question-group").prev();
  if (prevElement.hasClass("clear")) {
    prevElement = prevElement.prev();
  }
  prevElement.addClass("char-spacing");
  if (prevElement.hasClass("errors-container")) {
    if (prevElement.prev().find(".char-space").size() <= 0) {
      prevElement.prev().append("<span class='char-space'></div>");
    }
  }

  // Creates the character count elements
  this.wrap("<div class='char-count'></div>");
  this.after("<div class='char-text'>Word count: <span class='current-count'>0</span></div>");

  // Includes character limit if there is one
  this.each(function(){
    var maxlength = parseInt($(this).attr("data-word-max"), 10);
    if (maxlength) {
      $(this).before("<div class='char-text-limit'>Word limit: <span class='total-count'>" +maxlength+ "</span></div>");
      $(this).closest(".char-count").addClass("char-max-shift");
      $(this).closest(".char-count").find(".char-text").append("/<span class='total-count'>" +maxlength+ "</span>");

      // hard limit to word count
      var maxlengthlimit = maxlength *0.1;
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
      }
    } else {
      textInput.removeAttr("maxlength");
    }

    $("textarea[maxlength]").each(function() {
      var text_events = $._data(this, "events");
      if (text_events) {
        if (!("keydown" in text_events)) {
          $(this).on("keydown keyup", function (e) {
            $(this).addClass("char-over-cut");
            while ($(this).hasClass("char-over-cut")) {
              Countable.once(this, cutOverChar);
            }
          });
        }
      }
    });
  };

  var countText = function(counter) {
    $(this).attr("data-counted-words", counter.words);
  };

  // Maxlength for pasting text
  $(this).on("paste", function (e) {
    var textInput = $(this);

    if ((e.originalEvent || e).clipboardData) {
      alert(1);
      var oldText = textInput.val();
      var copyText = ((e.originalEvent || e).clipboardData.getData("text/plain"));

      if (!copyText.length > 0) {
        e.preventDefault();

        textInput.after("<div id='oldText'>"+oldText+"</div>");
        Countable.once($("#oldText")[0], countText);
        textInput.after("<div id='copyText'>"+copyText+"</div>");
        Countable.once($("#copyText")[0], countText);
        var oldTextCount = parseInt($("#oldText").attr("data-counted-words"), 10);
        var copyTextCount = parseInt($("#copyText").attr("data-counted-words"), 10);
        $("#oldText").remove();
        $("#copyText").remove();
        var wordMax = parseInt(textInput.attr("data-word-max"), 10);
        var wordMaxLimit = parseInt(textInput.attr("data-word-max-limit"), 10);
        var wordTotal = wordMax + wordMaxLimit;
        var wordsNeeded = wordTotal - oldTextCount;
        var newCopytext = copyText;
        if (copyTextCount > wordsNeeded) {
          var copyPartIndex = copyText.split(" ", wordsNeeded).join(" ").length;
          newCopytext = $.trim(copyText.substr(0, copyPartIndex)) + " ";
        }

        if (newCopytext) {
          textInput.val(textInput.val() + newCopytext);
          Countable.once(this, counting);
        }
      }
    } else {
      setTimeout(function() {
        textInput.addClass("char-over-cut");
        while (textInput.hasClass("char-over-cut")) {
          Countable.once(textInput[0], cutOverChar);
        }
      }, 10);
    }
  });

  this.each(function() {
    // Makes word count dynamic
    Countable.live(this, counting);
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
