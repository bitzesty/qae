// Gets character limit and allows no more
$(function() {
  // Creates the character count elements
  $(".js-char-count").wrap("<div class='char-count'></div>")
  $(".js-char-count").after("<div class='char-text'>Word count: <span class='current-count'>0</span></div>");

  // Includes charact limit if there is one
  $(".js-char-count").each(function(){
    var maxlength = $(this).attr('data-word-max');
    if (maxlength) {
      $(this).closest(".char-count").find(".char-text").append("/<span class='total-count'>" +maxlength+ "</span>")
    }
  });

  function counting (counter) {
    textInput = $(this)

    textInput.closest(".char-count").find(".char-text .current-count").text(counter.words);

    // If character count is over the limit then show error
    if (counter.words > textInput.attr('data-word-max')) {
      textInput.closest(".char-count").addClass("char-over");
    } else {
      textInput.closest(".char-count").removeClass("char-over");
    }
  }

  $(".js-char-count").each(function() {
    Countable.live($(this)[0], counting)
  });
});
