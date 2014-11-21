#= require jquery
#= require jquery_ujs
#= require ./frontend/textarea-autoResize
#= require ./frontend/text-character-count
#= require_tree .

jQuery ->
  # Hidden hints as seen on
  # https://www.gov.uk/service-manual/user-centred-design/resources/patterns/help-text
  $(document).on "click", ".hidden-hint a", (e) ->
    e.preventDefault()
    $(this).closest(".hidden-hint").toggleClass("show-hint")

  # Conditional questions that appear depending on answers
  $(".js-conditional-answer input").change () ->
    answer = $(this).closest(".js-conditional-answer").attr("data-answer")
    question = $(".js-conditional-question[data-answer='#{answer}']")
    answerVal = $(this).val()
    if $(this).attr('type') == 'checkbox'
      answerVal = $(this).is(':checked').toString()

    if question.attr('data-value') == answerVal
      question.addClass("show-question")
    else
      question.removeClass("show-question")
