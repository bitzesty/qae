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
      # highlight the error sections in sidebar and in error message
      $(".steps-progress-bar .js-step-link[data-step=#{page.attr('data-step')}]").addClass("step-errors")
      $(".js-review-sections").empty()
      $(".steps-progress-bar .step-errors a").each ->
        step_link = $(this).parent().html()
        step_link = step_link.replace("step-errors", "").replace("step-current", "")
        $(".js-review-sections").append("<li>#{step_link}</li>")

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

  compareDateInDays: (_d1, _d2) ->
    date = @toDate(_d1)
    expected = @toDate(_d2)

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
          @log_this(question, "validateRequiredQuestion", "This field is required")
          @addErrorMessage($(subquestion), "This field is required")
    else
      if not @validateSingleQuestion(question)
        @log_this(question, "validateRequiredQuestion", "This field is required")
        @addErrorMessage(question, "This field is required")

  validateMatchQuestion: (question) ->
    q = question.find(".match")
    match_name = q.data("match")

    if q.val() isnt $("input[name='#{match_name}']").val()
      @log_this(question, "validateMatchQuestion", "Emails don't match")
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
      @log_this(question, "validateMaxDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @log_this(question, "validateMaxDate", "Date cannot be after #{expDate}")
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
      @log_this(question, "validateMinDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diff > 0
      @log_this(question, "validateMinDate", "Date cannot be before #{expDate}")
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
      @log_this(question, "validateBetweenDate", "Not a valid date")
      @addErrorMessage(question, "Not a valid date")
      return

    if diffStart < 0 or diffEnd > 0
      @log_this(question, "validateBetweenDate", "Date should be between #{expDateStart} and #{expDateEnd}")
      @addErrorMessage(question, "Date should be between #{expDateStart} and #{expDateEnd}")

  validateNumber: (question) ->
    val = question.find("input")

    if not val
      return

    if not val.val().toString().match(@numberRegex) && val.val().toString().toLowerCase().trim() != "n/a"
      @log_this(question, "validateNumber", "Not a valid number")
      @addErrorMessage(question, "Not a valid number")

  validateEmployeeMin: (question) ->
    for subquestion in question.find("input")
      shown_question = true
      for conditional in $(subquestion).parents('.js-conditional-question')
        if !$(conditional).hasClass('show-question')
          shown_question = false

      if shown_question
        subq = $(subquestion)
        if not subq.val() and question.hasClass("question-required")
          @log_this(question, "validateEmployeeMin", "This field is required")
          @appendMessage(subq.closest(".span-financial"), "This field is required")
          @addErrorClass(question)
          continue
        else if not subq.val()
          continue

        if not subq.val().toString().match(@numberRegex)
          @log_this(question, "validateEmployeeMin", "Not a valid number")
          @appendMessage(subq.closest(".span-financial"), "Not a valid number")
          @addErrorClass(question)
        else
          subq_list = subq.closest(".row").find(".span-financial")
          subq_index = subq_list.index(subq.closest(".span-financial"))

          if subq_index == subq_list.size() - 1
            employee_limit = 2
          else
            employee_limit = 1

          if parseInt(subq.val()) < employee_limit
            @log_this(question, "validateEmployeeMin", "Minimum of #{employee_limit} employees")
            @appendMessage(subq.closest(".span-financial"), "Minimum of #{employee_limit} employees")
            @addErrorClass(question)

  validateCurrentAwards: (question) ->
    for subquestion in question.find(".list-add li")
      error_text = ""
      $(subquestion).find("select, input, textarea").each ->
        if !$(this).val()
          field_name = $(this).data("dependable-option-siffix")
          field_name = field_name[0].toUpperCase() + field_name.slice(1)
          field_error = "#{field_name} can't be blank. "
          error_text += field_error
      if error_text
        @log_this(question, "validateCurrentAwards", error_text)
        @appendMessage($(subquestion), error_text)
        @addErrorClass(question)

  validateMoneyByYears: (question) ->
    input_cells_counter = 0

    # Checking if question has min value for first year
    financial_conditional_block = question.find(".js-financial-conditional").first()
    first_year_min_value = financial_conditional_block.data("first-year-min-value")
    if typeof(first_year_min_value) != typeof(undefined)
      first_year_min_validation = true

    for subquestion in question.find("input")
      shown_question = true
      for conditional in $(subquestion).parents('.js-conditional-question')
        if !$(conditional).hasClass('show-question')
          shown_question = false

      if shown_question
        input_cells_counter += 1

        subq = $(subquestion)
        if not subq.val() and question.hasClass("question-required")
          @log_this(question, "validateMoneyByYears", "This field is required")
          @appendMessage(subq.closest("label"), "This field is required")
          @addErrorClass(question)
          continue
        else if not subq.val()
          continue

        value = subq.val().toString()
        err_container = subq.closest(".span-financial")

        if not value.match(@numberRegex)
          @log_this(question, "validateMoneyByYears", "Not a valid currency value")
          @appendMessage(err_container, "Not a valid currency value")
          @addErrorClass(question)
        else
          # if value is valid currency and it's first cell and
          # and question has min value for first year value
          # and value less than min value
          if input_cells_counter == 1 && first_year_min_validation && (value < first_year_min_value)
            message = financial_conditional_block.data("first-year-min-validation-message")
            @log_this(question, "validateMoneyByYears", message)
            @appendMessage(err_container, message)
            @addErrorClass(question)

  validateDateByYears: (question) ->

    for subquestion_block in question.find(".js-fy-entry-container.show-question .date-input")
      subq = $(subquestion_block)
      q_parent = subq.closest(".js-fy-entries")
      errors_container = q_parent.find(".errors-container").html()

      day = subq.find("input.js-fy-day").val()
      month = subq.find("input.js-fy-month").val()
      year = subq.find("input.js-fy-year").val()

      if (not day or not month or not year)
        if question.hasClass("question-required") && errors_container.length < 1
          @appendMessage(q_parent, "This field is required")
          @addErrorClass(question)
      else
        complex_date_string = day + "/" + month + "/" + year
        date = @toDate(complex_date_string)

        if not date.isValid()
          @log_this(question, "validateDateByYears", "Not a valid date")
          @appendMessage(q_parent, "Not a valid date")
          @addErrorClass(question)

  validateDateStartEnd: (question) ->
    if question.find(".validate-date-start-end").length > 0
      root_this = @
      question.find(".validate-date-start-end").each () ->
        # Whether we need to validate if date is ongoing
        if $(this).find(".validate-date-end input[disabled]").size() == 0
          startYear = parseInt($(this).find(".validate-date-start .js-date-input-year").val())
          startMonth = parseInt($(this).find(".validate-date-start .js-date-input-month").val())
          startDate = "01/#{startMonth}/#{startYear}"

          endYear = parseInt($(this).find(".validate-date-end .js-date-input-year").val())
          endMonth = parseInt($(this).find(".validate-date-end .js-date-input-month").val())
          endDate = "01/#{endMonth}/#{endYear}"

          diff = root_this.compareDateInDays(startDate, endDate)

          if not root_this.toDate(startDate).isValid()
            root_this.log_this(question, "validateDateStartEnd", "Not a valid date")
            root_this.addErrorMessage($(this).find(".validate-date-start").closest("span"), "Not a valid date")

          else if not root_this.toDate(endDate).isValid()
            root_this.log_this(question, "validateDateStartEnd", "Not a valid date")
            root_this.addErrorMessage($(this).find(".validate-date-end").closest("span"), "Not a valid date")

          else if diff > 0
            root_this.log_this(question, "validateDateStartEnd", "Start date cannot be after end date")
            root_this.addErrorMessage($(this), "Start date cannot be after end date")

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
      @log_this(question, "validateDropBlockCondition", error_message)
      @addErrorMessage(question, error_message)
      return

  validateSupportLetters: (question) ->
    letters_received = $(".js-support-letter-received").size()
    if letters_received < 2
      @log_this(question, "validateSupportLetters", "You need to request or upload at least 2 letters of support")
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
        @log_this(question, "validateGoodsServicesPercentage", "% of your total overseas trade should add up to 100")
        @appendMessage(question, "% of your total overseas trade should add up to 100")
        @addErrorClass(question)

  # It's for easy debug of validation errors
  # As it really tricky to find out the validation which blocks form
  # and do not display any error massage on form
  log_this: (question, validator, message) ->
    step_data = question.closest(".js-step-condition").data("step")
    step_title = $.trim($("a.js-step-link[data-step='#{step_data}']").text())
    q_ref = $.trim(question.find("h2 span.visuallyhidden").text())
    q_title = $.trim(question.find("h2").first().text())

    if typeof console != "undefined"
      console.log "-----------------------------"
      console.log("[STEP]: " + step_title)
      console.log("  [QUESTION] " + q_ref + ": "+ q_title)
      console.log("  [" + validator + "]: " + message)
      console.log "-----------------------------"

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

      #console.log @validates

    return @validates
