jQuery ->
  # Truncate the feedback
  $(".feedback-description").each ->
    full_text = $.trim($(this).text())
    if full_text.length >= 200
      short_text = full_text.substr(0, 200)
      short_text_div = "<div class='excerpt-text'>#{short_text}...</div>"
      read_more_text = "<span class='read-more'>Read more</span>"
      read_less_text = "<span class='read-less'>Read less</span>"
      read_more_link = "<a href='#' class='read-link'>#{read_more_text}#{read_less_text}</a>"

      $(this).addClass("full-text")
      $(this).wrap("<div class='read-more-container'>")
      $(this).closest(".read-more-container").prepend(short_text_div)
      $(this).closest(".read-more-container").append(read_more_link)
  $(".read-more-container .read-link").on "click", (e) ->
    e.preventDefault()
    $(this).closest(".read-more-container").toggleClass("open")

