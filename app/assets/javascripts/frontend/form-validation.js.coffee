window.FormValidation =
  validates: true
  # validates numbers, including floats and negatives
  numberRegex: /^-?\d*\,?\d*\,?\d*\,?\d*\,?\d*\.?\,?\d*$/

  clearAllErrors: ->
    @validates = true
    $(".question-has-errors").removeClass("question-has-errors")
    $(".errors-container").empty()
    $(".steps-progress-bar .js-step-link").removeClass("step-errors")

  clearErrors: (container) ->
    if container.closest(".question-financial").size() > 0
      if container.closest("label").find(".errors-container li").size() > 0
        container.closest("label").find(".errors-container").empty()
    else
      if container.closest(".question-block").find(".errors-container li").size() > 0
        container.closest(".question-block").find(".errors-container").empty()
    container.closest(".question-has-errors").removeClass("question-has-errors")

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
      # highlight the error sections in sidebar and in error message
      $(".steps-progress-bar .js-step-link[data-step=#{page.attr('data-step')}]").addClass("step-errors")
      $(".js-review-sections").empty()
      $(".steps-progress-bar .step-errors a").each ->
        stepLink = $(this).parent().html()
        stepLink = stepLink.replace("step-errors", "").replace("step-current", "")
        $(".js-review-sections").append("<li>#{stepLink}</li>")

      # uncheck confirmation of entry
      $(".question-block[data-answer='entry_confirmation-confirmation-of-entry'] input[type='checkbox']").prop("checked", false)
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

  compareDateInDays: (date1, date2) ->
    date = @toDate(date1)
    expected = @toDate(date2)

    date.diff(expected, "days")

  validateSingleQuestion: (question) ->
    if question.find("input").hasClass("not-required")
      return true
    else
      if @isTextishQuestion(question)
        return question.find("input[type='text'], input[type='number'], input[type='password'], input[type='email'], input[type='url'], textarea").val().toString().trim().length

      if @isSelectQuestion(question)
        return question.find("select").val()

      if @isOptionsQuestion(question)
        return question.find("input[type='radio']").filter(":checked").length

      if @isCheckboxQuestion(question)
        return question.find("input[type='checkbox']").filter(":checked").length

  validateRequiredQuestion: (question) ->
    # if it's a conditional question, but condition was not satisfied
    conditional = true

    if question.find(".js-by-trade-goods-and-services-amount").size() > 0
      # If it's the trade B1 question which has multiple siblings that have js-conditional-question
      if question.find(".js-conditional-question.show-question .js-by-trade-goods-and-services-amount .js-conditional-question.show-question").size() == 0
        conditional = false
    else
      question.find(".js-conditional-question").each ->
        if !$(this).hasClass("show-question")
          conditional = false

    if !conditional
      return

    # This handles questions with multiple fields,
    # like name and address
    if question.find(".js-by-trade-goods-and-services-amount").size() > 0
      # If it's the trade B1 question which has multiple siblings that have js-conditional-question
      subquestions = question.find(".js-by-trade-goods-and-services-amount .js-conditional-question.show-question .question-group")
    else
      subquestions = question.find(".question-group .question-group")

    if subquestions.length
      for subquestion in subquestions
        if not @validateSingleQuestion($(subquestion))
          @logThis(question, "validateRequiredQuestion", "This field is required")
          @addErrorMessage($(subquestion), "This field is required")
    else
      if not @validateSingleQuestion(question)
        @logThis(question, "validateRequiredQuestion", "This field is required")
        @addErrorMessage(question, "This field is required")

  validateMatchQuestion: (question) ->
    q = question.find(".match")
    matchName = q.data("match")

    if q.val() isnt $("input[name='#{matchName}']").val()
      @logThis(question, "validateMatchQuestion", "Emails don't match")
      @addErrorMessage(question, "Emails don't match")

  validateMaxDate: (question) ->
    val = question.find("input[type='text']").val()

    questionYear = parseInt(question.find(".js-date-input-year").val())
    questionMonth = parseInt(question.find(".js-date-input-month").val())
    questionDay = parseInt(question.find(".js-date-input-day").val())
    questionDate = "#{questionDay}/#{questionMonth}/#{questionYear}"

    if not val
      return

    expDate = question.data("date-max")
    diff = @compareDateInDays(questionDate, expDate)

    if not @toDate(questionDate).isValid()
      @logThis(question, "validateMaxDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @logThis(question, "validateMaxDate", "Date cannot be after #{expDate}")
      @addErrorMessage(question, "Date cannot be after #{expDate}")

  validateDynamicMaxDate: (question) ->
    val = question.find("input[type='text']").val()

    questionYear = parseInt(question.find(".js-date-input-year").val())
    questionMonth = parseInt(question.find(".js-date-input-month").val())
    questionDay = parseInt(question.find(".js-date-input-day").val())
    questionDate = "#{questionDay}/#{questionMonth}/#{questionYear}"

    if not val
      return

    if !$(".js-entry-period input:checked").length
      return

    entryPeriodVal = $(".js-entry-period input:checked").val()

    if !entryPeriodVal
      return

    settings = question.data("dynamic-date-max")

    expDate = settings.dates[entryPeriodVal]

    diff = @compareDateInDays(questionDate, expDate)

    if not @toDate(questionDate).isValid()
      @logThis(question, "validateMaxDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @logThis(question, "validateMaxDate", "Date cannot be after #{expDate}")
      @addErrorMessage(question, "Date cannot be after #{expDate}")

  validateMinDate: (question) ->
    val = question.find("input[type='text']").val()

    questionYear = parseInt(question.find(".js-date-input-year").val())
    questionMonth = parseInt(question.find(".js-date-input-month").val())
    questionDay = parseInt(question.find(".js-date-input-day").val())
    questionDate = "#{questionDay}/#{questionMonth}/#{questionYear}"

    if not val
      return

    expDate = question.data("date-min")
    diff = @compareDateInDays(questionDate, expDate)

    if not @toDate(questionDate).isValid()
      @logThis(question, "validateMinDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @logThis(question, "validateMinDate", "Date cannot be before #{expDate}")
      @addErrorMessage(question, "Date cannot be before #{expDate}")

  validateBetweenDate: (question) ->
    val = question.find("input[type='text']").val()

    questionYear = parseInt(question.find(".js-date-input-year").val())
    questionMonth = parseInt(question.find(".js-date-input-month").val())
    questionDay = parseInt(question.find(".js-date-input-day").val())
    questionDate = "#{questionDay}/#{questionMonth}/#{questionYear}"

    if not val
      return

    dates = question.data("date-between").split(",")
    expDateStart = dates[0]
    expDateEnd = dates[1]
    diffStart = @compareDateInDays(questionDate, expDateStart)
    diffEnd = @compareDateInDays(questionDate, expDateEnd)

    if not @toDate(questionDate).isValid()
      @logThis(question, "validateBetweenDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diffStart < 0 or diffEnd > 0
      @logThis(question, "validateBetweenDate", "Date should be between #{expDateStart} and #{expDateEnd}")
      @addErrorMessage(question, "Date should be between #{expDateStart} and #{expDateEnd}")

  validateNumber: (question) ->
    val = question.find("input")

    if not val
      return

    if not val.val().toString().match(@numberRegex) && val.val().toString().toLowerCase().trim() != "n/a"
      @logThis(question, "validateNumber", "Not a valid number")
      @addErrorMessage(question, "Not a valid number")

  validateEmployeeMin: (question) ->
    for subquestion in question.find("input")
      shownQuestion = true
      for conditional in $(subquestion).parents('.js-conditional-question')
        if !$(conditional).hasClass('show-question')
          shownQuestion = false

      if shownQuestion
        subq = $(subquestion)
        if not subq.val() and question.hasClass("question-required")
          @logThis(question, "validateEmployeeMin", "This field is required")
          @appendMessage(subq.closest(".span-financial"), "This field is required")
          @addErrorClass(question)
          continue
        else if not subq.val()
          continue

        if not subq.val().toString().match(@numberRegex)
          @logThis(question, "validateEmployeeMin", "Not a valid number")
          @appendMessage(subq.closest(".span-financial"), "Not a valid number")
          @addErrorClass(question)
        else
          subqList = subq.closest(".row").find(".span-financial")
          subqIndex = subqList.index(subq.closest(".span-financial"))
          employeeLimit = 2

          if parseInt(subq.val()) < employeeLimit
            @logThis(question, "validateEmployeeMin", "Minimum of #{employeeLimit} employees")
            @appendMessage(subq.closest(".span-financial"), "Minimum of #{employeeLimit} employees")
            @addErrorClass(question)

  validateCurrentAwards: (question) ->
    $(".errors-container", question).empty()

    for subquestion in question.find(".list-add li")
      errorText = ""
      $(subquestion).find("select, input, textarea").each ->
        if !$(this).val()
          fieldName = $(this).data("dependable-option-siffix")
          fieldName = fieldName[0].toUpperCase() + fieldName.slice(1)
          fieldError = "#{fieldName} can't be blank. "
          errorText += fieldError
      if errorText
        @logThis(question, "validateCurrentAwards", errorText)
        @appendMessage($(subquestion), errorText)
        @addErrorClass(question)

  validateMoneyByYears: (question) ->
    inputCellsCounter = 0

    # Checking if question has min value for first year
    financialConditionalBlock = question.find(".js-financial-conditional").first()
    firstYearMinValue = financialConditionalBlock.data("first-year-min-value")
    if typeof(firstYearMinValue) != typeof(undefined)
      firstYearMinValidation = true

    for subquestion in question.find("input")
      subq = $(subquestion)
      errContainer = subq.closest(".span-financial")

      shownQuestion = true
      for conditional in $(subquestion).parents('.js-conditional-question')
        if !$(conditional).hasClass('show-question')
          shownQuestion = false

      if shownQuestion
        inputCellsCounter += 1

        if not subq.val() and question.hasClass("question-required")
          @logThis(question, "validateMoneyByYears", "This field is required")
          @appendMessage(errContainer, "This field is required")
          @addErrorClass(question)
          continue
        else if not subq.val()
          continue

        value = subq.val().toString()

        if not $.trim(value).match(@numberRegex)
          @logThis(question, "validateMoneyByYears", "Not a valid currency value")
          @appendMessage(errContainer, "Not a valid currency value")
          @addErrorClass(question)
        else
          # if value is valid currency and it's first cell and
          # and question has min value for first year value
          # and value less than min value
          if inputCellsCounter == 1 && firstYearMinValidation && (value < firstYearMinValue)
            message = financialConditionalBlock.data("first-year-min-validation-message")
            @logThis(question, "validateMoneyByYears", message)
            @appendMessage(errContainer, message)
            @addErrorClass(question)

  validateDateByYears: (question) ->

    for subquestionBlock in question.find(".js-fy-entry-container.show-question .date-input")
      subq = $(subquestionBlock)
      qParent = subq.closest(".js-fy-entries")
      errorsContainer = qParent.find(".errors-container").html()

      day = subq.find("input.js-fy-day").val()
      month = subq.find("input.js-fy-month").val()
      year = subq.find("input.js-fy-year").val()

      if (not day or not month or not year)
        if question.hasClass("question-required") && errorsContainer.length < 1
          @appendMessage(qParent, "This field is required")
          @addErrorClass(question)
      else
        complexDateString = day + "/" + month + "/" + year
        date = @toDate(complexDateString)

        if not date.isValid()
          @logThis(question, "validateDateByYears", "Not a valid date")
          @appendMessage(qParent, "Not a valid date")
          @addErrorClass(question)

  validateDateStartEnd: (question) ->
    if question.find(".validate-date-start-end").length > 0
      rootThis = @
      question.find(".validate-date-start-end").each () ->
        # Whether we need to validate if date is ongoing
        if $(this).find(".validate-date-end input[disabled]").size() == 0
          startYear = parseInt($(this).find(".validate-date-start .js-date-input-year").val())
          startMonth = parseInt($(this).find(".validate-date-start .js-date-input-month").val())
          startDate = "01/#{startMonth}/#{startYear}"

          endYear = parseInt($(this).find(".validate-date-end .js-date-input-year").val())
          endMonth = parseInt($(this).find(".validate-date-end .js-date-input-month").val())
          endDate = "01/#{endMonth}/#{endYear}"

          diff = rootThis.compareDateInDays(startDate, endDate)

          if not rootThis.toDate(startDate).isValid()
            rootThis.logThis(question, "validateDateStartEnd", "Not a valid date")
            rootThis.addErrorMessage($(this).find(".validate-date-start").closest("span"), "Not a valid date")

          else if not rootThis.toDate(endDate).isValid()
            rootThis.logThis(question, "validateDateStartEnd", "Not a valid date")
            rootThis.addErrorMessage($(this).find(".validate-date-end").closest("span"), "Not a valid date")

          else if diff > 0
            rootThis.logThis(question, "validateDateStartEnd", "Start date cannot be after end date")
            rootThis.addErrorMessage($(this), "Start date cannot be after end date")

        return

  validateDropBlockCondition: (question) ->

    if $("[name='form[financial_year_date_changed]']:checked").val() is "yes"
      return

    drop = false
    lastVal = 0

    $.each question.find(".currency-input input"), (index, el) ->
      if $(el).val() && (!$(el).closest(".conditional-question").length || $(el).closest(".conditional-question").hasClass("show-question"))
        value = parseFloat $(el).val()
        if value < lastVal
          drop = true
        lastVal = value

    if drop
      errorMessage = "Sorry, you are not eligible. \
      You must have constant growth in overseas sales for the entire entry period to be eligible \
      for a Queen's Award for Enterprise: International Trade."
      @logThis(question, "validateDropBlockCondition", errorMessage)
      @addErrorMessage(question, errorMessage)
      return

  validateSupportLetters: (question) ->
    lettersReceived = $(".js-support-letter-received").size()
    if lettersReceived < 2
      @logThis(question, "validateSupportLetters", "You need to request or upload at least 2 letters of support")
      @appendMessage(question, "You need to request or upload at least 2 letters of support")
      @addErrorClass(question)

  validateGoodsServicesPercentage: (question) ->
    totalOverseasTradeInputs = question.find(".js-by-trade-goods-and-services-amount .show-question input[type='text']")
    totalOverseasTradePercentage = 0
    missingOverseasTradeValue = false
    totalOverseasTradeInputs.each ->
      if $(this).val().toString().trim().length
        totalOverseasTradePercentage += parseInt $(this).val()
      else
        missingOverseasTradeValue = true
    if !missingOverseasTradeValue
      if totalOverseasTradePercentage != 100
        @logThis(question, "validateGoodsServicesPercentage", "% of your total overseas trade should add up to 100")
        @appendMessage(question, "% of your total overseas trade should add up to 100")
        @addErrorClass(question)

  # It's for easy debug of validation errors
  # As it really tricky to find out the validation which blocks form
  # and do not display any error massage on form
  logThis: (question, validator, message) ->
    stepData = question.closest(".js-step-condition").data("step")
    stepTitle = $.trim($("a.js-step-link[data-step='#{stepData}']").text())
    qRef = $.trim(question.find("h2 span.visuallyhidden").text())
    qTitle = $.trim(question.find("h2").first().text())

    if typeof console != "undefined"
      console.log "-----------------------------"
      console.log("[STEP]: " + stepTitle)
      console.log("  [QUESTION] " + qRef + ": "+ qTitle)
      console.log("  [" + validator + "]: " + message)
      console.log "-----------------------------"

  hookIndividualValidations: ->
    self = @

    $(document).on "change", ".question-block input, .question-block select, .question-block textarea", ->
      self.clearErrors $(this)

      self.validateIndividualQuestion($(@).closest(".question-block"))

  validateIndividualQuestion: (question) ->
    if question.hasClass("question-required") and not question.hasClass("question-date-by-years") and not question.hasClass("question-money-by-years")
      # console.log "validateRequiredQuestion"
      @validateRequiredQuestion(question)

    if question.hasClass("question-number")
      # console.log "validateNumber"
      @validateNumber(question)

    if question.hasClass("question-money-by-years")
      # console.log "validateMoneyByYears"
      @validateMoneyByYears(question)

    if question.hasClass("question-date-by-years") &&
       question.find(".show-question").length == (question.find(".js-conditional-question").length - 1)
      # console.log "validateDateByYears"
      @validateDateByYears(question)

    if question.find(".match").length
      # console.log "validateMatchQuestion"
      @validateMatchQuestion(question)

    if question.hasClass("question-date-max")
      # console.log "validateMaxDate"
      @validateMaxDate(question)

    if question.hasClass("question-dynamic-date-max")
      @validateDynamicMaxDate(question)

    if question.hasClass("question-date-min")
      # console.log "validateMinDate"
      @validateMinDate(question)

    if question.hasClass("question-date-between")
      # console.log "validateBetweenDate"
      @validateBetweenDate(question)

    if question.hasClass("question-employee-min") &&
       question.find(".show-question").length > 0
      # console.log "validateEmployeeMin"
      @validateEmployeeMin(question)

    if question.hasClass("question-current-awards") &&
       question.find(".show-question").length > 0
      # console.log "validateCurrentAwards"
      @validateCurrentAwards(question)

    if question.find(".validate-date-start-end").size() > 0
      # console.log "validateDateStartEnd"
      @validateDateStartEnd(question)

    if question.hasClass("js-conditional-drop-block-answer")
      # console.log "validateDropBlockCondition"
      @validateDropBlockCondition(question)

    if question.hasClass("question-support-requests") ||
       question.hasClass("question-support-uploads")
      # console.log "validateSupportLetters"
      @validateSupportLetters(question)

    if question.find(".js-by-trade-goods-and-services-amount").length
      # console.log "validateGoodsServicesPercentage"
      @validateGoodsServicesPercentage(question)

  validate: ->
    @clearAllErrors()

    for question in $(".question-block")
      question = $(question)
      # console.log "----"
      # console.log question.find("h2").text()

      @validateIndividualQuestion(question)

      #console.log @validates

    return @validates

  validateStep: (step = null) ->
    @validates = true

    currentStep = step || $(".js-step-link.step-current").attr("data-step")

    stepContainer = $(".article-container[data-step='" + currentStep + "']")

    stepContainer.find(".question-has-errors").removeClass("question-has-errors")
    stepContainer.find(".errors-container").empty()
    $(".steps-progress-bar .js-step-link[data-step='" + currentStep + "']").removeClass("step-errors")

    for question in stepContainer.find(".question-block")
      question = $(question)
      @validateIndividualQuestion(question)
