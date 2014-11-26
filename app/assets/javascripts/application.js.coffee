#= require jquery
#= require jquery_ujs
#= require ./frontend/textarea-autoResize
#= require ./frontend/text-character-count
#= require_tree .

jQuery ->
  # Hidden hints as seen on
  # https://www.gov.uk/service-manual/user-centred-design/resources/patterns/help-text
  # Creates the links and adds the arrows
  $(".hidden-link").wrap("<a href='#'></a>")
  # Adds the arrows
  $(".hidden-link").closest("a").prepend("<span class='hidden-arrow-right'>▶</span><span class='hidden-arrow-down'>▼</span>")
  # Adds click event to links
  $(document).on "click", ".hidden-hint a", (e) ->
    e.preventDefault()
    $(this).closest(".hidden-hint").toggleClass("show-hint")

  # Conditional questions that appear depending on answers
  $(".js-conditional-question").addClass("conditional-question")
  $(".js-conditional-answer input, .js-conditional-answer select").change () ->
    answer = $(this).closest(".js-conditional-answer").attr("data-answer")
    question = $(".conditional-question[data-question='#{answer}']")
    answerVal = $(this).val()

    console.log "#{question} : #{answer} : #{answerVal}"

    if $(this).attr('type') == 'checkbox'
      answerVal = $(this).is(':checked').toString()

    if question.attr('data-value') == answerVal
      question.addClass("show-question")
    else
      question.removeClass("show-question")
