#= require jquery
#= require jquery_ujs
#= require Countable
#= require moment.min
#= require_tree .

jQuery ->

  triggerAutosave = (e) ->
    window.autosave_timer ||= setTimeout( autosave, 15000 )

  isTextishQuestion = (question) ->
    question.find("input[type='text'], input[type='number'], input[type='password'], textarea").length

  isSelectQuestion = (question) ->
    question.find("select").length

  isOptionsQuestion = (question) ->
    question.find("input[type='radio']").length

  isCheckboxQuestion = (question) ->
    question.find("input[type='checkbox']").length

  validateSingleQuestion = (question) ->
    if isTextishQuestion(question)
      return question.find("input[type='text'], input[type='number'], input[type='password'], textarea").val().toString().length

    if isSelectQuestion(question)
      return question.find("select").val()

    if isOptionsQuestion(question)
      return question.find("input[type='radio']").filter(":checked").length

    if isCheckboxQuestion(question)
      return question.find("input[type='checkbox']").filter(":checked").length

  validate = ->
    required = $("div.step-current .question-required")

    validates = true

    for question in required
      q = $(question)

      q.removeClass("question-has-errors")
      q.find(".errors-container").empty()
      
      # if it's a conditional question, but condition was not satisfied
      if q.find(".js-conditional-question").length and not q.find(".js-conditional-question").hasClass("show-question")
        continue

      if not validateSingleQuestion(q)
        q.find(".errors-container").first().append("<li>This field is required</li>")
        q.addClass("question-has-errors")

        validates = false

    for question in $("div.step-current .question-date-max")
      q = $(question)

      q.removeClass("question-has-errors")
      q.find(".errors-container").empty()

      input = q.find("input[type='text']")

      if not input.val()
        continue

      expDate = q.data("date-max")
      expected = moment(expDate, "DD/MM/YYYY")
      date = moment(input.val(), "DD/MM/YYYY")

      if not date.isValid() or date.diff(expected, "days") > 0
        q.find(".errors-container").append("<li>Date cannot be after #{expDate}</li>")
        q.addClass("question-has-errors")
        validates = false

    for question in $("div.step-current .question-date-min")
      q = $(question)

      q.removeClass("question-has-errors")
      q.find(".errors-container").empty()

      input = q.find("input[type='text']")

      if not input.val()
        continue

      expDate = q.data("date-min")
      expected = moment(expDate, "DD/MM/YYYY")
      date = moment(input.val(), "DD/MM/YYYY")

      if not date.isValid() or date.diff(expected, "days") < 0
        q.find(".errors-container").append("<li>Date cannot be before #{expDate}</li>")
        q.addClass("question-has-errors")
        validates = false

    for question in $("div.step-current .question-date-between")
      q = $(question)

      q.removeClass("question-has-errors")
      q.find(".errors-container").empty()

      input = q.find("input[type='text']")

      if not input.val()
        continue

      dates = q.data("date-between").split(",")
      expDateStart = dates[0]
      expDateEnd = dates[1]
      expectedStart = moment(expDateStart, "DD/MM/YYYY")
      expectedEnd = moment(expDateEnd, "DD/MM/YYYY")
      date = moment(input.val(), "DD/MM/YYYY")

      if not date.isValid() or date.diff(expectedStart, "days") < 0 or date.diff(expectedEnd, "days") > 0
        q.find(".errors-container").append("<li>Date must be between #{expDateStart} and #{expDateEnd}</li>")
        q.addClass("question-has-errors")
        validates = false

    for question in $("div.step-current .question-number")
      q = $(question)

      q.removeClass("question-has-errors")
      q.find(".errors-container").empty()

      input = q.find("input")

      if not input.val()
        continue

      if not input.val().toString().match(/^-?\d*\.?\d*$/)
        q.find(".errors-container").append("<li>Not a valid number</li>")
        q.addClass("question-has-errors")
        validates = false

    for question in $("div.step-current .question-money-by-years")
      q = $(question)

      q.removeClass("question-has-errors")
      q.find(".errors-container").empty()

      subquestions = q.find(".js-conditional-question.show-question input")

      for subquestion in subquestions
        subq = $(subquestion)

        subq.parent().find(".errors-container").empty()

        if not subq.find("input").val() and q.hasClass("question-required")
          subq.parent().find(".errors-container").append("<li>This field is required.</li>")
          q.addClass("question-has-errors")
          validates = false
        else if not subq.val()
          continue

        if not subq.val().toString().match(/^-?\d*\.?\d*$/)
          subq.parent().find(".errors-container").append("<li>Not a valid number</li>")
          q.addClass("question-has-errors")
          validates = false

    for question in $("div.step-current .question-date-by-years")
      q = $(question)

      q.removeClass("question-has-errors")
      q.find(".errors-container").empty()

      subquestions = q.find(".js-conditional-question.show-question input")

      for subquestion in subquestions
        subq = $(subquestion).parent()

        subq.find(".errors-container").empty()

        if not subq.find("input").val() and q.hasClass("question-required")
          subq.parent().find(".errors-container").append("<li>This field is required.</li>")
          q.addClass("question-has-errors")
          validates = false
        else if not subq.find("input").val()
          continue

        dates = subq.find(".date-range").text().split(" - ")
        expDateStart = dates[0]
        expDateEnd = dates[1]
        expectedStart = moment(expDateStart, "DD/MM/YYYY")
        expectedEnd = moment(expDateEnd, "DD/MM/YYYY")
        date = moment(subq.find("input").val(), "DD/MM/YYYY")

        if not date.isValid()
          subq.parent().find(".errors-container").append("<li>Not a valid date</li>")
          q.addClass("question-has-errors")
          validates = false

        if date.diff(expectedStart, "days") < 0 or date.diff(expectedEnd, "days") > 0
          subq.parent().find(".errors-container").append("<li>Date is out of range.</li>")
          q.addClass("question-has-errors")
          validates = false

    return validates

  $(document).on "submit", ".qae-form", (e) ->
    if not validate()
      
      $("html, body").animate(
        scrollTop: 0
      , 0)
      return false

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
  $(".js-conditional-question, .js-conditional-drop-question").addClass("conditional-question")
  # Simple conditional using a == b
  simpleConditionalQuestion = (input, clicked) ->
    answer = input.closest(".js-conditional-answer").attr("data-answer")
    question = $(".conditional-question[data-question='#{answer}']")
    answerVal = input.val()

    if input.attr('type') == 'checkbox'
      answerVal = input.is(':checked').toString()

    question.each () ->
      if $(this).attr('data-value') == answerVal || ($(this).attr('data-value') == "true" && (answerVal != 'false' && answerVal != false))
        if clicked || (!clicked && input.attr('type') == 'radio' && input.is(':checked'))
          $(this).addClass("show-question")
      else
        if clicked || (!clicked && input.attr('type') != 'radio')
          $(this).removeClass("show-question")
  $(".js-conditional-answer input, .js-conditional-answer select").each () ->
    simpleConditionalQuestion($(this), false)
  $(".js-conditional-answer input, .js-conditional-answer select").change () ->
    simpleConditionalQuestion($(this), true)
  # Numerical conditional that checks that trend doesn't ever drop
  dropConditionalQuestion = (input) ->
    drop_question = input.closest(".js-conditional-drop-answer").attr('data-drop-question')
    question = $(".js-conditional-answer[data-answer='#{drop_question}']").closest(".js-conditional-drop-question")
    drop = false

    $(".js-conditional-drop-answer[data-drop-question='#{drop_question}']").each () ->
      drop_answers = $(this).closest(".js-conditional-drop-answer")
      last_val = 0

      drop_answers.find("input").each () ->
        if $(this).val()
          value = parseFloat $(this).val()
          if value < last_val
            drop = true
          last_val = value

    if drop
      question.addClass("show-question")
    else
      question.removeClass("show-question")
  $(".js-conditional-drop-answer input").each () ->
    dropConditionalQuestion($(this))
  $(".js-conditional-drop-answer input").change () ->
    dropConditionalQuestion($(this))

  # Get the year value from previous answer
  updateYearEnd = () ->
    $(".js-year-end").each () ->
      year = $(this).attr("data-year")
      value = $("input[data-year='#{year}']").val()

      if value
        $(this).text(value)
      else
        $(this).text("...")
  updateYearEnd()
  $("input[data-year]").change () ->
    updateYearEnd()

  # Show/hide the correct step/page for the award form
  showAwardStep = (step) ->
    $(".js-step-condition.step-current").removeClass("step-current")

    if ($ 'form.award-form').length && (($ 'form.award-form').data('eligible') == 'false' || !($ 'form.award-form').data('eligible'))
      window.location.hash = "#eligibility"
      $(".js-step-condition[data-step='step-eligibility']").addClass("step-current")
      alert('Sorry, you are not eligible for the award') unless step == 'step-eligibility'
    else
      window.location.hash = "##{step.substr(5)}"
      $(".js-step-condition[data-step='#{step}']").addClass("step-current")

    # Show past link status
    $(".steps-progress-bar .js-step-link.step-past").removeClass("step-past")

    current_index = $(".steps-progress-bar .js-step-link").index($(".steps-progress-bar .step-current"))
    $(".steps-progress-bar .js-step-link").each () ->
      this_index = $(".steps-progress-bar .js-step-link").index($(this))
      if this_index < current_index
        $(this).addClass("step-past")

  if window.location.hash
    showAwardStep("step-#{window.location.hash.substr(1)}")
    # Resize textareas that were previously hidden
    resetResizeTextarea()
  $(document).on "click", ".js-step-link", (e) ->
    e.preventDefault()
    if !$(this).hasClass("step-current")
      current = $(this).attr("data-step")
      if $(this).hasClass "next"
        if validate()
          showAwardStep(current)
      else
        showAwardStep(current)
      # Scroll to top
      $("html, body").animate(
        scrollTop: 0
      , 0)
      # Resize textareas that were previously hidden
      resetResizeTextarea()

  autosave = () ->
    window.autosave_timer = null
    url = $('form.qae-form').data('autosave-url')
    if url
      form_data = {}
      a = $('form.qae-form').serializeArray()
      $.each a,
        (() ->
          if form_data[@name] != undefined
            if !form_data[@name].push
              form_data[@name] = [form_data[@name]]
            form_data[@name].push(@value || '')
          else
            form_data[@name] = @value || '')
      $.ajax({
        url: url
        data: JSON.stringify(form_data)
        contentType: 'application/json'
        type: 'POST'
        dataType: 'json'
      })
    #TODO: indicators, error handlers?

  triggerAutosave = (e) ->
    window.autosave_timer ||= setTimeout( autosave, 15000 )

  checkEligibility = (event) ->
    if $('form.qae-form').data('eligibility-check-url')
      form_data = {}
      a = $('form.qae-form').serializeArray()
      $.each a,
        (() ->
          if form_data[@name] != undefined
            if !form_data[@name].push
              form_data[@name] = [form_data[@name]]
            form_data[@name].push(@value || '')
          else
            form_data[@name] = @value || '')
      $.ajax({
        url: $('form.qae-form').data('eligibility-check-url')
        data: JSON.stringify(form_data)
        contentType: 'application/json'
        type: 'POST'
        dataType: 'json'
      }).success (isEligible) ->
        ($ 'form.award-form').data('eligible', isEligible)

  $(document).on "change", ".js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "input[type='text'].js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "input[type='number'].js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "input[type='url'].js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "input[type='tel'].js-trigger-autosave", triggerAutosave
  $(document).on "keyup", "textarea.js-trigger-autosave", triggerAutosave
  $(document).on "change", "div[class*=' eligibility_'] input, div[class^='eligibility_'] input", checkEligibility
  $(document).on "change", "div[class*=' basic_eligibility_'] input, div[class^='basic_eligibility_'] input", checkEligibility

  # Fade out alerts after 5sec
  $(".flash").delay(5000).fadeOut()

  # Show current holder info when they are a current holder on basic eligibility current holder question
  if $(".eligibility_current_holder").size() > 0
    $(".eligibility_current_holder input").change () ->
      if $(this).val() == "true"
        $("#current-holder-info").removeClass("visuallyhidden")
      else
        $("#current-holder-info").addClass("visuallyhidden")

  # Show innovation amount info when the amount is greater than 1 on innovation eligibility
  if $(".innovative_amount_input").size() > 0
    $(".innovative_amount_input").bind "propertychange change click keyup input paste", () ->
      if $(this).val() > 1
        $("#innovative-amount-info").removeClass("visuallyhidden")
      else
        $("#innovative-amount-info").addClass("visuallyhidden")

  # Show the eligibility failure contact message
  if $("#basic-eligibility-failure-submit").size() > 0
    $(document).on "click", "#basic-eligibility-failure-submit", (e) ->
      e.preventDefault()
      if $(this).closest("form").find("input:checked").val()
        $("#basic-eligibility-failure-answered").addClass("visuallyhidden")
        $("#basic-eligibility-failure-show").removeClass("visuallyhidden")

  # Change your eligibility answers for award eligibility
  if $(".award-finish-previous-answers").size() > 0
    $(document).on "click", ".award-finish-previous-answers a", (e) ->
      e.preventDefault()
      $("#form_eligibility_show").addClass("visuallyhidden")
      $("#form_eligibility_questions").removeClass("visuallyhidden")

  # Clicking `+ Add` on certain questions add fields
  $(document).on "click", ".question-block .js-button-add", (e) ->
    e.preventDefault()

    question = $(this).closest(".question-block")
    add_example = question.find(".js-add-example").html()

    # If there is a specific add_example use that
    attr = $(this).attr("data-add-example")
    if ((typeof(attr) != typeof(undefined)) && attr != false)
      add_example = question.find(".js-add-example[data-add-example=#{attr}]").html()

    if question.find(".list-add").size() > 0
      question.find(".list-add").append("<li>#{add_example}</li>")
  # Removing these added fields
  $(document).on "click", ".question-block .list-add .js-remove-link", (e) ->
    e.preventDefault()
    $(this).closest("li").remove()
