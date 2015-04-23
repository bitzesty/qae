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
    if (counter.words > maxWordCount) {
      textInput.closest(".char-count").addClass("char-over");
    }

    if (counter.words > maxWordCountTotal) {
      return true;
    } else if (counter.words == maxWordCountTotal && lastLetter == " ") {
      return true;
    }
  };

  var counting = function(counter) {
    var textInput = $(this);

    textInput.closest(".char-count").find(".char-text .current-count").text(counter.words);

    if (characterOver(counter, textInput)) {
      // hard limit to word count using maxlength
      if (((typeof(textInput.attr("maxlength")) !== typeof(undefined)) && textInput.attr("maxlength") !== false) == false) {
        // Set through typing
        var char_limit = textInput.val().length;
        textInput.attr("maxlength", char_limit);
      }
    } else {
      textInput.removeAttr("maxlength");
    }
  }

  // Maxlength for pasting text
  this.bind("paste", function(e){
    var originalText = $(this).val();
    originalText += ((e.originalEvent || e).clipboardData.getData("text/plain"));

    if (originalText.length > 0) {
      e.preventDefault();
      var charTest = $(this).after("<p class='char-count-test'></p>");
      charTest.attr("data-word-max", $(this).attr("data-word-max"));
      charTest.attr("data-word-max-limit", $(this).attr("data-word-max-limit"));
      var lastChar = 0;
      $(this).val("");
      for (var c = 0; c<originalText.length; c++) {
        if (((typeof(charTest.attr("maxlength")) !== typeof(undefined)) && charTest.attr("maxlength") !== false) === false || c <= charTest.attr("maxlength")) {
          charTest.text(originalText.substr(0, c + 1));
          Countable.once(charTest[0], counting);
        }
        if (((typeof(charTest.attr("maxlength")) !== typeof(undefined)) && charTest.attr("maxlength") !== false) === false || c <= charTest.attr("maxlength")) {
          lastChar = c;
        }
      }
      $(this).val(originalText.substr(0, lastChar + 1));
      Countable.once(this, counting);
      $(".char-count-test").remove();
    }
  });

  this.each(function() {
    // Makes word count dynamic
    Countable.live(this, counting);
  });

  return this;
}
// Gets character limit and allows no more
$(function() {
  // Creates the character count elements
  $(".js-char-count").charcount();
});


$.fn.removeCharcountElements = function() {
  // Removes the character count elements
  $(this).unwrap();
  $(".char-text, .char-text-limit", $(this).closest("li")).remove();
}
