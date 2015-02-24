window.FormValidation =
  validates: true
  # validates numbers, including floats and negatives
  numberRegex: /^-?\d*\,?\d*\,?\d*\,?\d*\,?\d*\.?\,?\d*$/

  clearAllErrors: ->
    @validates = true
    $(".question-has-errors").removeClass("question-has-errors")
    $(".errors-container").empty()
    $(".steps-progress-bar .js-step-link").removeClass("step-errors")

  addErrorMessage: (question, message) ->
    @appendMessage(question, message)
    @addErrorClass(question)

    @validates = false

  appendMessage: (container, message) ->
    container.find(".errors-container").first().append("<li>#{message}</li>")
    @validates = false

  addErrorClass: (container) ->
    container.addClass("question-has-errors")
    page = container.closest(".step-article")
    if !page.hasClass("step-errors")
      $(".steps-progress-bar .js-step-link[data-step=#{page.attr('data-step')}]").addClass("step-errors")
    @validates = false

  isTextishQuestion: (question) ->
    question.find("input[type='text'], input[type='number'], input[type='password'], input[type='email'], input[type='url'], textarea").length

  isSelectQuestion: (question) ->
    question.find("select").length

  isOptionsQuestion: (question) ->
    question.find("input[type='radio']").length

  isCheckboxQuestion: (question) ->
    question.find("input[type='checkbox']").length

  toDate: (str) ->
    moment(str, "DD/MM/YYYY")

  compareDateInDays: (_d1, _d2) ->
    date = @toDate(_d1)
    expected = @toDate(_d2)

    date.diff(expected, "days")

  validateSingleQuestion: (question) ->
    if @isTextishQuestion(question)
      return question.find("input[type='text'], input[type='number'], input[type='password'], input[type='email'], input[type='url'], textarea").val().toString().length

    if @isSelectQuestion(question)
      return question.find("select").val()

    if @isOptionsQuestion(question)
      return question.find("input[type='radio']").filter(":checked").length

    if @isCheckboxQuestion(question)
      return question.find("input[type='checkbox']").filter(":checked").length

  validateRequiredQuestion: (question) ->
    # if it's a conditional question, but condition was not satisfied
    conditional = true
    question.find(".js-conditional-question").each () ->
      if !$(this).hasClass("show-question")
        conditional = false

    if !conditional
      return

    # This handles questions with multiple fields,
    # like name and address
    if question.find(".question-group .question-group").length
      for subquestion in question.find(".question-group .question-group")
        if not @validateSingleQuestion($(subquestion))
          @addErrorMessage($(subquestion), "This field is required.")
    else
      if not @validateSingleQuestion(question)
        @addErrorMessage(question, "This field is required.")

  validateMatchQuestion: (question) ->
    q = question.find(".match")
    match_name = q.data("match")

    if q.val() isnt $("input[name='#{match_name}']").val()
      @addErrorMessage(question, "Emails don't match.")

  validateMaxDate: (question) ->
    val = question.find("input[type='text']").val()

    if not val
      return

    expDate = question.data("date-max")
    diff = @compareDateInDays(val, expDate)

    if not @toDate(val).isValid()
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @addErrorMessage(question, "Date cannot be after #{expDate}")

  validateMinDate: (question) ->
    val = question.find("input[type='text']").val()

    if not val
      return

    expDate = question.data("date-max")
    diff = @compareDateInDays(val, expDate)

    if not @toDate(val).isValid()
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @addErrorMessage(question, "Date cannot be before #{expDate}")

  validateBetweenDate: (question) ->
    val = question.find("input[type='text']").val()

    if not val
      return

    dates = question.data("date-between").split(",")
    expDateStart = dates[0]
    expDateEnd = dates[1]
    diffStart = @compareDateInDays(val, expDateStart)
    diffEnd = @compareDateInDays(val, expDateEnd)

    if not @toDate(val).isValid()
      @addErrorMessage(question, "Not a valid date")
      return

    if diffStart < 0 or diffEnd > 0
      @addErrorMessage(question, "Date should be between #{expDateStart} and #{expDateEnd}.")

  validateNumber: (question) ->
    val = question.find("input")

    if not val
      return

    if not val.val().toString().match(@numberRegex) && val.val().toString().toLowerCase().trim() != "n/a"
      @addErrorMessage(question, "Not a valid number")

  validateTotalOverseas: () ->
    questions = $(".question-block[data-answer='overseas_sales-total-overseas-sales'] .show-question .currency-input")
    direct = $(".question-block[data-answer='overseas_sales_direct-of-which-direct'] .show-question .currency-input")
    indirect = $(".question-block[data-answer='overseas_sales_indirect-of-which-indirect'] .show-question .currency-input")

    $(".question-block[data-answer='overseas_sales-total-overseas-sales']").removeClass("question-has-errors")

    total_doesnt_match = false

    for question,i in questions
      $(question).find(".errors-container").empty()

      val = parseFloat($(question).find("input").val() or 0)
      dir = parseFloat($(direct[i]).find("input").val() or 0)
      ind = parseFloat($(indirect[i]).find("input").val() or 0)

      if (dir + ind) != val
        total_doesnt_match = true

    if total_doesnt_match
      question_block = $(".question-block[data-answer='overseas_sales-total-overseas-sales']")
      @appendMessage(question_block, "Total doesn't match values from questions below.")
      @addErrorClass(question_block)
      return

  validateMoneyByYears: (question) ->
    for subquestion in question.find("input")
      shown_question = true
      for conditional in $(subquestion).parents('.js-conditional-question')
        if !$(conditional).hasClass('show-question')
          shown_question = false

      if shown_question
        subq = $(subquestion)
        if not subq.val() and question.hasClass("question-required")
          @appendMessage(subq.closest("label"), "This field is required.")
          @addErrorClass(question)
          continue
        else if not subq.val()
          continue

        if not subq.val().toString().match(@numberRegex)
          @appendMessage(subq.closest("label"), "Not a valid currency value.")
          @addErrorClass(question)

  validateDateByYears: (question) ->
    for subquestion in question.find(".js-conditional-question.show-question input")
      if $(subquestion).closest(".js-conditional-question").hasClass("show-question")
        subq = $(subquestion)

        val = subq.val()

        if not val and question.hasClass("question-required")
          @appendMessage(subq.parent(), "This field is required.")
          @addErrorClass(question)
          continue
        else if not val
          continue

        dates = subq.parent().find(".date-range").text().trim().split(" - ")
        expDateStart = dates[0]
        expDateEnd = dates[1]
        date = @toDate(val)

        if not date.isValid()
          @appendMessage(subq.parent(), "Not a valid date")
          @addErrorClass(question)

        if @compareDateInDays(val, expDateStart) < 0 or @compareDateInDays(val, expDateEnd) > 0
          @appendMessage(subq.parent(), "Date should be between #{expDateStart} and #{expDateEnd}.")
          @addErrorClass(question)

  validateDateStartEnd: () ->
    question.find(".validate-date-start-end").each () ->
      # Whether we're checking just year or month as well
      dateInputCount = $(this).find(".validate-date-start label").size()

      for i in [dateInputCount-1..0] by -1
        startDate = parseInt($(this).find(".validate-date-start label:eq("+i+") input").val())
        endDate = parseInt($(this).find(".validate-date-end label:eq("+i+") input").val())

        if startDate > endDate
          @appendMessage(subq.parent(), "Start date cannot be after end date")
          @addErrorClass(question)
          return

  validateDropBlockCondition: (question) ->
    drop = false
    last_val = 0

    $.each question.find(".currency-input input"), (index, el) ->
      if $(el).val()
        value = parseFloat $(el).val()
        if value < last_val
          drop = true
        last_val = value

    if drop
      error_message = "Sorry, you are not eligible. \
      You must have constant growth in overseas sales for the entire entry period to be eligible \
      for a Queen's Award for Enterprise: International Trade."
      @addErrorMessage(question, error_message)
      return

  validate: ->
    @clearAllErrors()

    for _q in $(".question-block")
      question = $(_q)
      # console.log "----"
      # console.log question.find("h2").text()

      if question.hasClass("question-required") and not question.hasClass("question-date-by-years") and not question.hasClass("question-money-by-years")
        # console.log "validateRequiredQuestion"
        @validateRequiredQuestion(question)

      if question.hasClass("question-number")
        # console.log "validateNumber"
        @validateNumber(question)

      if question.hasClass("question-money-by-years")
        # console.log "validateMoneyByYears"
        @validateMoneyByYears(question)

      if question.hasClass("question-date-by-years")
        # console.log "validateDateByYears"
        @validateDateByYears(question)

      if question.find(".match").length
        # console.log "validateMatchQuestion"
        @validateMatchQuestion(question)

      if question.hasClass("question-date-max")
        # console.log "validateMaxDate"
        @validateMaxDate(question)

      if question.hasClass("question-date-min")
        # console.log "validateMinDate"
        @validateMinDate(question)

      if question.hasClass("question-date-between")
        # console.log "validateBetweenDate"
        @validateBetweenDate(question)

      if question.attr("data-answer") == 'overseas_sales-total-overseas-sales' &&
         question.find(".show-question").length > 0
        # console.log "validateTotalOverseas"
        @validateTotalOverseas()

      if question.find(".validate-date-start-end").size() > 0
        # console.log "validateDateStartEnd"
        @validateDateStartEnd(question)

      if question.hasClass("js-conditional-drop-block-answer")
        # console.log "validateDropBlockCondition"
        @validateDropBlockCondition(question)

      #console.log @validates

    return @validates
