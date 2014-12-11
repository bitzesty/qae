window.FormValidation =
  validates: true
  # validates numbers, including floats and negatives
  numberRegex: /^-?\d*\.?\,?\d*$/

  clearAllErrors: ->
    @validates = true
    $("div.step-current .question-has-errors").removeClass("question-has-errors")
    $("div.step-current .errors-container").empty()

  addErrorMessage: (question, message) ->
    @appendMessage(question, message)
    @addErrorClass(question)

    @validates = false

  appendMessage: (container, message) ->
    container.find(".errors-container").first().append("<li>#{message}</li>")
    @validates = false

  addErrorClass: (container) ->
    container.addClass("question-has-errors")
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
    if question.find(".js-conditional-question").length and not question.find(".js-conditional-question").hasClass("show-question")
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

    if not val.val().toString().match(@numberRegex)
      @addErrorMessage(question, "Not a valid number")

  validateTotalOverseas: () ->
    questions = $(".question-block[data-answer='overseas_sales-total-overseas-sales'] .question-group .conditional-question.show-question .row span")
    direct = $(".question-block[data-answer='overseas_sales_direct-of-which-direct'] .question-group .conditional-question.show-question .row span")
    indirect = $(".question-block[data-answer='overseas_sales_indirect-of-which-indirect'] .question-group .conditional-question.show-question .row span")

    $(".question-block[data-answer='overseas_sales-total-overseas-sales']").removeClass("question-has-errors")
    
    for question,i in questions
      $(question).find(".errors-container").empty()

      val = parseFloat($(question).find("input").val() or 0)
      dir = parseFloat($(direct[i]).find("input").val() or 0)
      ind = parseFloat($(indirect[i]).find("input").val() or 0)

      if (dir + ind) != val
        @appendMessage(question, "Total doesn't match values from questions below.")
        @addErrorClass($(".question-block[data-answer='overseas_sales-total-overseas-sales']"))

  validateMoneyByYears: (question) ->
    for subquestion in question.find(".js-conditional-question.show-question input")
      subq = $(subquestion)

      if not subq.val() and question.hasClass("question-required")
        @appendMessage(subq.parent(), "This field is required.")
        @addErrorClass(question)
        continue
      else if not subq.val()
        continue

      if not subq.val().toString().match(@numberRegex)
        @appendMessage(subq.parent(), "Not a valid currency value.")
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

  validate: ->
    @clearAllErrors()

    for _q in $("div.step-current .question-block")
      question = $(_q)

      #if question.hasClass("question-required") and not question.hasClass("question-date-by-years") and not question.hasClass("question-money-by-years")
      #  @validateRequiredQuestion(question)

      #if question.hasClass("question-number")
      #  @validateNumber(question)

      #if question.hasClass("question-money-by-years")
      #  @validateMoneyByYears(question)

      #if question.hasClass("question-date-by-years")
      #  @validateDateByYears(question)

      #if question.find(".match").length
      #  @validateMatchQuestion(question)

      #if question.hasClass("question-date-max")
      #  @validateMaxDate(question)

      #if question.hasClass("question-date-min")
      #  @validateMinDate(question)

      #if question.hasClass("question-date-between")
      #  @validateBetweenDate(question)

      #if $(".question-block[data-answer='overseas_sales-total-overseas-sales'] > .conditional-question").hasClass("show-question")
      #  @validateTotalOverseas()

    return @validates
