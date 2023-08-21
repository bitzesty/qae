#= require govuk-frontend-3.13.0.min
#= require jquery
#= require jquery_ujs
#= require vendor/file_upload/jquery.ui.widget
#= require vendor/file_upload/jquery.iframe-transport
#= require vendor/file_upload/jquery.fileupload
#= require vendor/file_upload/jquery.fileupload-process
#= require vendor/file_upload/jquery.fileupload-validate
#= require ./ckeditor/config.js
#= require Countable
#= require moment.min
#= require core
#= require libs/suchi/isOld.js
#= require libs/pusher.min.js
#= require mobile
#= require browser-check
#= require vendor/zxcvbn
#= require vendor/accessible-autocomplete.min
#= require vendor/jquery-debounce
#= require vendor/details.polyfill.js
#= require js.cookie
#= require_tree ./frontend
#= require offline

safeParse = (str) ->
  try
    return JSON.parse(str)
  catch _err
    return str
  return

diffFromSequence = (str, separator = "of") ->
  try
    parts = str.split(separator).map (value) ->
      parseInt(value)

    return parts[1] - parts[0]
  catch _err
    return undefined
  return

# Added for subtracting years from date
# Handles also leap years
yearsFromDate = (input, years, format = false) ->
  months = (years * 12) - 1

  date = new Date(
    input.getFullYear(), 
    input.getMonth() + months, 
    Math.min(
      input.getDate(), 
      new Date(input.getFullYear(), input.getMonth() + months + 1, 0).getDate()
    )
  )

  if format
    date.toLocaleDateString('en-GB') 
  else
    date

# Conditional latest year
# If from 6th of September to December -> then previous year
# If from January to 6th of September -> then current year
#
getLatestFinancialYearParts = () ->
  fy_day = $('.js-financial-year-latest input.js-fy-day').val()
  fy_month = $('.js-financial-year-latest input.js-fy-month').val()

  if gon?
    fy_year = gon.base_year || new Date().getFullYear()
  else
    fy_year = new Date().getFullYear()

  # Conditional latest year
  # If from 6th of September to December -> then previous year
  # If from January to 6th of September -> then current year
  if (parseInt(fy_month, 10) == 9 && parseInt(fy_day, 10) >= 7) || parseInt(fy_month, 10) > 9
    fy_year = parseInt(fy_year, 10) - 1

  if $(".js-most-recent-financial-year input:checked").val() && $(".js-most-recent-financial-year .js-conditional-question").hasClass("show-question")
    fy_year = parseInt($(".js-most-recent-financial-year input:checked").val())

  return [fy_day, fy_month, fy_year]

ordinal = (n) ->
  nHundreds = n % 100
  nDecimal = n % 10

  if nHundreds in [11, 12, 13]
    return n + "th"
  else
    if nDecimal is 1
      return n + "st"
    else if nDecimal is 2
      return n + "nd"
    else if nDecimal is 3
      return n + "rd"

    return n + "th"

jQuery ->
  # GOVUK.details.init();
  # GOVUKFrontend.initAll();

  $("html").removeClass("no-js")

  offlineCheck = new Offline
  offlineCheck.start()

  # This is a very primitive way of testing.
  # Should be refactored once forms stabilize.
  #
  # TODO: Refactor this later on
  validate = ->
    window.FormValidation.validate()

  window.changesUnsaved = false

  window.FormValidation.hookIndividualValidations()

  $(document).on "submit", ".qae-form", (e) ->
    $("body").addClass("tried-submitting")
    if not validate()
      $("body").addClass("show-error-page")
      $(".steps-progress-bar .step-current").removeClass("step-current")
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
    e.stopPropagation()

    $(this).closest(".hidden-hint").toggleClass("show-hint")

  $(document).on "click", ".hidden-link-for", (e) ->
    e.preventDefault()
    link_href = $(this).attr("href").substr(1)
    hidden_link = $(this).closest(".question-block").find("."+link_href)
    hidden_link.toggleClass("show-hint")

  $(".supporters-list input").change ->
    $(this).closest("label").find(".govuk-error-message").empty()
    $(this).closest(".govuk-form-group--error").removeClass("govuk-form-group--error")

  # Conditional questions that appear depending on answers
  $(".js-conditional-question, .js-conditional-drop-question").addClass("conditional-question")
  # Simple conditional using a == b
  simpleConditionalQuestion = (input, clicked) ->
    answer = input.closest(".js-conditional-answer").attr("data-answer")
    question = $(".conditional-question[data-question='#{answer}']")
    isCheckbox = input.attr('type') == 'checkbox'
    checkboxVal = input.val()
    answerVal = if isCheckbox then input.is(':checked').toString() else input.val()
    boolean_values = ["0", "1", "true", "false"]
    values = input.closest(".govuk-form-group").find("input[type='checkbox']").filter(":checked").map(() -> $(@).val()).toArray()

    question.each () ->
      nonBooleanCheckboxMeetsCriteria = isCheckbox && $(this).attr('data-value') in values
      if $(this).attr('data-value') == answerVal || nonBooleanCheckboxMeetsCriteria || ($(this).attr('data-value') == "true" && (answerVal != 'false' && answerVal != false)) || ($(this).attr('data-type') == "in_clause_collection" && $(this).attr('data-value') <= answerVal)
        if clicked || (!clicked && input.attr('type') == 'radio' && input.is(':checked')) || (!clicked && input.attr('type') != 'radio')
          $(this).addClass("show-question")
      else
        if clicked || (!clicked && input.attr('type') != 'radio')
          $(this).removeClass("show-question")
  $(".js-conditional-answer input, .js-conditional-answer select").each () ->
    simpleConditionalQuestion($(this), false)
  $(".js-conditional-answer input, .js-conditional-answer select").change () ->
    setTimeout((() =>
      simpleConditionalQuestion($(this), true)
    ), 50)
  # Range conditional using a is within range
  rangeConditionalQuestion = (input) ->
    block = input.closest(".js-conditional-answer")
    answer = block.attr("data-answer")
    question = $(".conditional-question[data-question='#{answer}'][data-type='range']")

    d_input = block.find(".govuk-date-input")

    d_day_input = d_input.find("input.js-date-input-day")
    d_month_input = d_input.find("input.js-date-input-month")
    d_year_input = d_input.find("input.js-date-input-year")

    fy_day_input = d_input.find("input.js-fy-day")
    fy_month_input = d_input.find("input.js-fy-month")

    isFyRange = (fy_day_input && fy_month_input)

    if (fy_day_input.length && fy_month_input.length)
      d_day = fy_day_input.val()
      d_month = fy_month_input.val()
      d_year = 2000
    else
      d_day = d_day_input.val()
      d_month = d_month_input.val()
      d_year = d_year_input.val()

    if (d_day && d_month && d_year)
      question.each () ->
        range = safeParse($(this).attr('data-value'))

        if Array.isArray(range)
          from = range.at(0).split('/')
          to = range.at(-1).split('/')

          d_from = new Date(from[2], parseInt(from[1]) - 1, from[0])
          d_to = new Date(to[2], parseInt(to[1]) - 1, to[0]);
          d_input = new Date(d_year, parseInt(d_month) - 1, d_day);

          if (d_input >= d_from && d_input <= d_to)
            $(this).addClass("show-question")
          else
            $(this).removeClass("show-question")
    else
      question.each () ->
        if $(this).is('[data-default]')
          $(this).addClass("show-question")
        else
          $(this).removeClass("show-question")

  $(".js-conditional-answer .govuk-date-input input").each () ->
    rangeConditionalQuestion($(this))
  $(".js-conditional-answer .govuk-date-input input").change () ->
    setTimeout((() =>
      rangeConditionalQuestion($(this))
    ), 50)

  # Numerical conditional that checks that trend doesn't ever drop
  dropConditionalQuestion = (input) ->
    drop_question_ids = input.closest(".js-conditional-drop-answer").attr('data-drop-question')
    drop = false

    $(".js-conditional-drop-answer[data-drop-question='#{drop_question_ids}']").each () ->
      drop_answers = $(this).closest(".js-conditional-drop-answer")
      last_val = Math.log(0) # -Infinity

      drop_answers.find("input").each () ->
        if $(this).val()
          value = parseFloat $(this).val()
          if value < last_val || value < 0
            drop = true
          last_val = value

    $.each drop_question_ids.split(','), (index, id) ->
      parent_q = $(".js-conditional-answer[data-answer='#{id}']").closest(".js-conditional-drop-question")

      if drop
        parent_q.addClass("show-question")
      else
        parent_q.removeClass("show-question")

  $(".js-conditional-drop-answer input").each () ->
    dropConditionalQuestion($(this))
  $(".js-conditional-drop-answer input").change () ->
    dropConditionalQuestion($(this))

  $('[name="press_summary[correct]"]').on 'change', ->
    if ($(this).val() == 'true')
      $("#press-summary-comment-textarea-container").removeClass("if-js-hide")
    else
      $("#press-summary-comment-textarea-container").addClass("if-js-hide")

  # Get the latest financial year date from input
  updateYearEndInput = () ->
    fy_latest_changed_input = $(".js-financial-year-changed-dates .fy-latest .govuk-date-input")
    fy_latest_changed_input.find("input").removeAttr("readonly")

    [fy_day, fy_month, fy_year] = getLatestFinancialYearParts()

    # overriding financial year with the selected radio button value
    # also check if the question is visible
    if $(".js-most-recent-financial-year input:checked").val() && $(".js-most-recent-financial-year .js-conditional-question").hasClass("show-question")
      fy_year = parseInt($(".js-most-recent-financial-year input:checked").val())

    # Updates the latest changed financial year input
    fy_latest_changed_input.find("input.js-fy-day").val(fy_day)
    fy_latest_changed_input.find("input.js-fy-month").val(fy_month)

    # Auto fill the year for previous years
    # Disabled for year 2023
    # $(".js-financial-year-changed-dates .js-fy-entries").each ->
    #  if $(this).find("input.js-fy-year").val() == ""
    #    parent_fy = $(this).parent().find(".js-fy-entries")
    #    this_year = fy_year - (parent_fy.size() - parent_fy.index($(this)) - 1)
    #
    #    $(this).find("input.js-fy-year").val(this_year)

    fy_latest_changed_input.find("input").attr("readonly", "readonly")
    $(".js-financial-year-changed-dates").attr("data-year", fy_year)

    # We should change the last year date regardless if it's present or not
    fy_latest_changed_input.find("input.js-fy-year").val(fy_year)

    updateYearEnd()

  # Update the financial year labels
  updateYearEnd = () ->
    base = $(".js-financial-conditional .js-year-end")
    base.removeClass("show-both")
    base.removeClass("show-default")

    if $(".js-financial-year-change input:checked").val() == "no"
      # If the financial year haven't changed, clear manually entered dates
      $(".js-financial-year-changed-dates .js-fy-entries").each ->
        $(this).find("input.js-fy-day").removeAttr("readonly").val("")
        $(this).find("input.js-fy-month").removeAttr("readonly").val("")

      [fy_latest_day, fy_latest_month, fy_latest_year] = getLatestFinancialYearParts()

      if !fy_latest_day || !fy_latest_month || !fy_latest_year
        $(".js-year-end").addClass("show-default")
      else
        $(".js-year-end").each ->
          year = parseInt(fy_latest_year) + parseInt($(this).attr("data-year").substr(0, 1)) - parseInt($(this).attr("data-year").substr(-1, 1))
          $(this).addClass("show-both")
          $(this).find(".js-year-text").text("Year ended #{fy_latest_day}/#{fy_latest_month}/#{year}")
    else
      # Year has changed, use what they've inputted
      $(".js-financial-conditional > .by-years-wrapper").each ->
        all_years_value = true
        $(this).find(".js-year-end").each ->
          fy_input = $(".js-financial-year-changed-dates .js-year-end[data-year=#{$(this).attr("data-year")}]").closest(".js-fy-entries").find(".govuk-date-input")
          fy_day = fy_input.find(".js-fy-day").val()
          fy_month = fy_input.find(".js-fy-month").val()
          fy_year = fy_input.find(".js-fy-year").val()

          if !fy_day || !fy_month || !fy_year
            all_years_value = false
        if !all_years_value
          $(this).find(".js-year-end").each ->
            diff = diffFromSequence($(this).attr("data-year"))
            fy_count = $(".js-financial-year-changed-dates .by-years-wrapper.show-question .js-year-end").length
            fy_input = $(".js-financial-year-changed-dates .by-years-wrapper.show-question .js-year-end[data-year-diff='#{diff}']").closest(".js-fy-entries").find(".govuk-date-input")
            fy_day = fy_input.find(".js-fy-day").val()
            fy_month = fy_input.find(".js-fy-month").val()
            fy_year = fy_input.find(".js-fy-year").val()

            $(this).addClass("show-both")

            if fy_input.length > 0 && (!fy_day || !fy_month || !fy_year)
              $(this).find(".js-year-text").html("<br style='visibility:hidden'>")
            else if fy_input.length == 0
              # how many years to deduct from first FY if it's filled
              # current diff is always equeal or higher than no. of years
              surplus = parseInt(diff) + 1 - fy_count

              # the input from where we should start counting down ~> first FY after company started trading
              # this is just to get selector for the values
              diff = fy_count - 1

              fy_input = $(".js-financial-year-changed-dates .by-years-wrapper.show-question .js-year-end[data-year-diff='#{diff}']").closest(".js-fy-entries").find(".govuk-date-input")

              fy_day = fy_input.find(".js-fy-day").val()
              fy_month = fy_input.find(".js-fy-month").val()
              fy_year = fy_input.find(".js-fy-year").val()

              if !fy_day || !fy_month || !fy_year
                $(this).find(".js-year-text").html("<br style='visibility:hidden'>")
              else
                $(this).find(".js-year-text").text("Year ended #{yearsFromDate(new Date(fy_year, fy_month, fy_day), -(surplus), true)}")
            else
              $(this).find(".js-year-text").text("Year ended #{fy_day}/#{fy_month}/#{fy_year}")
        else
          $(this).find(".js-year-end").each ->
            fy_input = $(".js-financial-year-changed-dates .js-year-end[data-year='#{$(this).attr("data-year")}']").closest(".js-fy-entries").find(".govuk-date-input")
            fy_day = fy_input.find(".js-fy-day").val()
            fy_month = fy_input.find(".js-fy-month").val()
            fy_year = fy_input.find(".js-fy-year").val()
            $(this).addClass("show-both")
            $(this).find(".js-year-text").text("Year ended #{fy_day}/#{fy_month}/#{fy_year}")

  updateYearEndInput()

  fy_inputs = $(".js-financial-year input")
  fy_inputs.each () ->
    updateYearEndInput()
  fy_inputs.change () ->
    updateYearEndInput()

  fy_last_inputs = $(".js-financial-year-latest").closest(".question-block").next().find("input")
  fy_last_inputs.each () ->
    updateYearEnd()
  fy_last_inputs.change () ->
    updateYearEnd()

  $(".js-financial-year-changed-dates .govuk-date-input input").change ->
    setTimeout((() =>
      updateYearEnd()
    ), 50)

   $(".js-most-recent-financial-year input").change ->
    setTimeout((() =>
      updateYearEndInput()
    ), 50)

  $('.question-required').find('input,select,textarea').each ->
    $(this).prop('required', true)
    $(this).attr('aria-required', 'true')

  $('.qae-form').find('input[type="number"]').each ->
    $(this).attr('pattern', '[0-9]*')
    $(this).attr('inputmode', 'decimal')

  # Calculates the UK Sales for Sus Dev form
  # UK sales = turnover - exports
  updateTurnoverExportCalculation = ->
    $(".js-sales-value").each ->
      sales_year = $(this).data("year")
      turnover_data = $(this).data("turnover")
      exports_data = $(this).data("exports")
      turnover_selector = "[id='form["+turnover_data+"_"+sales_year+"]']"
      exports_selector = "[id='form["+exports_data+"_"+sales_year+"]']"
      $("#{turnover_selector}, #{exports_selector}").each ->
        $(this).attr("data-year", sales_year)
      $(document).on "change", "#{turnover_selector}, #{exports_selector}", ->
        sales_year = $(this).data("year")
        turnover_selector = "[id='form["+turnover_data+"_"+sales_year+"]']"
        exports_selector = "[id='form["+exports_data+"_"+sales_year+"]']"
        sales_selector = ".js-sales-value[data-year='"+sales_year+"']"
        sales_value = parseInt($(turnover_selector).val().replace(/,/g, '')) - parseInt($(exports_selector).val().replace(/,/g, ''))
        if sales_value
          $(sales_selector).text(sales_value)
        else
          $(sales_selector).text("0")

  updateTurnoverExportCalculation()

  replaceCommasInFinancialData = ->
    $(document).on "change", "input.js-form-financial-data", ->
      formatted_value = $(this).val().replace(/,/g, '')
      $(this).val(formatted_value)

  replaceCommasInFinancialData()

  updateRowTotalsCalculation = (inputFields) ->
    for inputField in inputFields
      inputField.addEventListener('input', ->
        row = this.closest('tr')
        inputFieldsInRow = row.querySelectorAll('td:not(:last-child) input[type="number"]');

        sum = 0
        for inputFieldInRow in inputFieldsInRow
          sum += parseInt(inputFieldInRow.value) or 0

        lastCell = row.cells[row.cells.length - 1];
        inputField = lastCell.querySelector('input[type="number"]');
        inputField.value = sum;
      )

  updateTotalValue = (cell, colSums) ->
    input = cell.querySelector('input')
    input?.value = colSums[cell.cellIndex]

  updateProportionValue = (cell, referenceRow, type, colSums) ->
    proportionInput = cell.querySelector('input')
    referenceCell = referenceRow[cell.cellIndex].querySelector('input')
    referenceValue = parseFloat(referenceCell?.value) or 0
    if type == 'disadvantaged'
      proportionInput?.value = ((referenceValue / colSums[cell.cellIndex]) * 100).toFixed(2)
    else if type == 'others'
      proportionInput?.value = ( colSums[cell.cellIndex] / (colSums[cell.cellIndex] + referenceValue) * 100).toFixed(2)

  calculateRowsToExcludeFromBottom = (table, className) ->
    rows = table.querySelectorAll('tr');
    for i in [rows.length - 1..0] by -1
      if rows[i].classList.contains(className)
        row_count_from_bottom = rows.length - i
        return row_count_from_bottom

  updateColumnTotalsCalculation = (table) ->
    inputFields = table.querySelectorAll('input[type="number"]')
    colCount = table.rows[0].cells.length
    totalsRow = table.querySelector('.auto-totals-row').cells
    subtotalsRowSelector = table.querySelector('.auto-subtotals-row')
    if subtotalsRowSelector
      subtotalsRow = subtotalsRowSelector.cells
      rowsToExclude = calculateRowsToExcludeFromBottom(table, 'auto-subtotals-row')
    else
      rowsToExclude = calculateRowsToExcludeFromBottom(table, 'auto-totals-row')
    othersRow = table.querySelector('.others-not-disadvantaged-row').cells
    disadvantagedRow = table.querySelector('tbody').querySelector('tr:nth-child(1)').cells
    proportionRow = table.querySelector('.auto-proportion-row').cells

    for inputField in inputFields
      inputField.addEventListener('input', ->
        colSums = {}
        for i in [0...colCount]
          columnIndex = i
          colSums[i] = 0

          for row in table.rows
            if row.rowIndex > 0 && row.rowIndex < table.rows.length - rowsToExclude
              inputElement = row.cells[columnIndex].querySelector('input')
              cellValue = parseFloat(inputElement?.value) or 0
              if !isNaN(cellValue)
                colSums[columnIndex] += cellValue

        if subtotalsRowSelector
          for cell in subtotalsRow
            updateTotalValue(cell, colSums)
          for cell in totalsRow
            totalInput = cell.querySelector('input')
            inputElement = othersRow[cell.cellIndex].querySelector('input')
            othersCellValue = parseFloat(inputElement?.value) or 0
            totalInput?.value = colSums[cell.cellIndex] + othersCellValue
        else
          for cell in totalsRow
            updateTotalValue(cell, colSums)

        for cell in proportionRow
          if subtotalsRowSelector
            updateProportionValue(cell, othersRow, 'others', colSums)
          else
            updateProportionValue(cell, disadvantagedRow, 'disadvantaged', colSums)
      )

  loopOverTables = ->
    updateRowTotalsCalculation(document.querySelectorAll('.auto-totals-column input[type="number"]'))

    autoTotalColTables = document.querySelectorAll('.auto-totals-row-table')
    for table in autoTotalColTables
      updateColumnTotalsCalculation(table)

  loopOverTables()

  # Show/hide the correct step/page for the award form
  showAwardStep = (step) ->
    $("body").removeClass("show-error-page")
    sub_step = null
    parent_step = step

    if step.indexOf("/") > -1
      parts = step.split("/")
      parent_step = parts[0]
      sub_step = parts[1]

    $(".js-step-condition.step-current").removeClass("step-current")

    window.location.hash = "##{step.substr(5)}"
    $(".js-step-condition[data-step='#{parent_step}']").addClass("step-current")

    if sub_step
      setTimeout(() ->
        $("##{sub_step}").attr('tabindex', '-1')
        $("##{sub_step}").focus()
        if $("##{sub_step}")[0].scrollIntoView
          $("##{sub_step}")[0].scrollIntoView({
            block: 'center'
          })
      , 100)
    else
      $(".js-step-condition[data-step='#{parent_step}'] h2").attr('tabindex', '-1')
      $(".js-step-condition[data-step='#{parent_step}'] h2").focus()

    # Show past link status
    $(".steps-progress-bar .js-step-link.step-past").removeClass("step-past")

    current_index = $(".steps-progress-bar .js-step-link").index($(".steps-progress-bar .step-current"))
    $(".steps-progress-bar .js-step-link").each () ->
      this_index = $(".steps-progress-bar .js-step-link").index($(this))
      if this_index < current_index
        $(this).addClass("step-past")

    # Setting current_step_id to form as we updating only current section form_data (not whole form)
    $("#current_step_id").val(step)

  if window.location.hash
    step = window.location.hash.substr(1)
    parent_step = step.split('/')[0]

    if $(".js-step-condition[data-step='step-#{parent_step}']").size() > 0
      showAwardStep("step-#{step}")
      # Resize textareas that were previously hidden
      resetResizeTextarea()
    else
      window.location.hash = $(".js-step-condition.step-current").attr("data-step").substr(5)

      # Setting current_step_id to form as we updating only current section form_data (not whole form)
      $("#current_step_id").val(step)

  $(".qae-form").on "submit", (e) ->
    if window.changesUnsaved
      e.preventDefault()
      e.stopPropagation()

      autosave ->
        $(".steps-progress-content .step-current button[type='submit']").click()

  #
  # In case if was attempt to submit and validation errors are present
  # then we are passing validate_on_form_load option
  # in order to show validation errors to user after redirection
  #
  if window.location.href.search("validate_on_form_load") > 0
    validate()

  $(document).on "click", "a.js-step-link, .js-step-link button[type='submit']", (e) ->
    e.preventDefault()
    e.stopPropagation()

    current_step = if $(this).attr('data-step') isnt undefined
      $(this).attr("data-step")
    else
      $(this).closest(".js-step-link").attr("data-step")

    window.FormValidation.validateStep()

    #
    # Make a switch to next section if this is not same tab only
    #
    if current_step != $(".js-step-link.step-current").attr('data-step')

      # If there are more than one one-time form collaborator
      #
      if ApplicationCollaboratorsGeneralRoomTracking.there_are_other_collaborators_here()
        CollaboratorsLog.log("[COLLABORATOR MODE] ----------------------- ")
        ApplicationCollaboratorsEditorBar.show_loading_bar()

        #
        # Getting url of next section to show
        #
        if $(this).prop("tagName") == "A"
          redirect_url = $(this).attr("href")
        else
          redirect_url = $("li.js-step-link.step-current").next().find("a").attr('href')

        #
        # System will redirect normal (NON AJAX) request
        # to "add-website-address-documents" step into related NON JS section
        # so that we need to pass extra 'no_redirect' option in this case
        #
        redirect_url += "&form_refresh=true"

        #
        # In case if was attempt to submit and validation errors are present
        # then we are passing validate_on_form_load option
        # in order to show validation errors to user after redirection
        #
        if window.location.href.search("validate_on_form_load") > 0 ||
           $(this).closest(".js-review-sections").length > 0 ||
           $(this).hasClass("step-errors")
          redirect_url += "&validate_on_form_load=true"

        CollaboratorsLog.log("[COLLABORATOR MODE] ------------ redirect_url ----------- " + redirect_url)

        if ApplicationCollaboratorsAccessManager.does_im_current_editor()
          CollaboratorsLog.log("[COLLABORATOR MODE] -------------I'm EDITOR---------- SAVE AND REDIRECT")
          # If I'm current editor
          # -> then save form data and once it saved redirect me to proper section in a callback
          #
          save_form_data ->
            window.location.href = redirect_url
        else
          CollaboratorsLog.log("[COLLABORATOR MODE] -------------I'm NOT EDITOR---------- REDIRECT TO TAB")
          # If I'm not editor
          # -> then just redirect to target section
          #
          window.location.href = redirect_url

      else
        CollaboratorsLog.log("[STANDART MODE] ----------------------- ")

        autosave()

        if $(this).hasClass "js-next-link"
          if $("body").hasClass("tried-submitting")
            validate()

        showAwardStep(current_step)

        # Scroll to top
        $("html, body").animate(
          scrollTop: 0
        , 0)

        # Resize textareas that were previously hidden
        resetResizeTextarea()

  $(document).on "change", ".js-financial-year-change input", (e) ->
    if $(".js-financial-year-change input:checked").val() == "yes"
      updateYearEndInput()
    updateYearEnd()

  $(document).on "click", ".save-quit-link a", (e) ->
    if window.changesUnsaved
      e.preventDefault()
      e.stopPropagation()

      link = $(@).attr("href")

      $(@).text("Saving...")

      autosave ->
        window.location.href = link

  save_form_data = (callback) ->
    url = $('form.qae-form').data('autosave-url')

    if url
      # Setting current_step_id to form as we updating only current section form_data (not whole form)
      $("#current_step_id").val($(".js-step-condition.step-current").attr("data-step"))

      form_data = $('form.qae-form').serialize()

      $.ajax({
        url: url
        data: form_data
        type: 'POST'
        dataType: 'json'
        success: ->
          window.changesUnsaved = false
          if callback isnt undefined
            callback()
        error: (e) ->
          # tricking onbeforereload
          window.changesUnsaved = false
          window.location.reload()
      })

  autosave = (callback) ->
    window.autosave_timer = null
    autosave_enabled = true

    if ApplicationCollaboratorsGeneralRoomTracking.there_are_other_collaborators_here() &&
       ApplicationCollaboratorsAccessManager.im_in_viewer_mode()
      #
      # If there are more than once collaborator for this form application
      #    and I'm not in editor mode of current form section
      #
      # Then autosave request should be disabled
      #
      autosave_enabled = false

    # Assessor viewing form, autosave should be disabled
    if $(".page-read-only-form").length > 0
      autosave_enabled = false

    if autosave_enabled
      save_form_data(callback)
    #TODO: indicators, error handlers?

  loseChangesMessage = "You have unsaved changes! If you leave the page now, some answers will be lost. Stay on the page for a minute in order for everything to be saved or use the buttons at the bottom of the page."

  window.onbeforeunload = ->
    if !$(".page-read-only-form").length
      if window.changesUnsaved then loseChangesMessage else undefined

  if window.addEventListener isnt undefined
    window.addEventListener "beforeunload", (e) ->
      return undefined unless window.changesUnsaved

      e.returnValue = loseChangesMessage
      loseChangesMessage

  triggerAutosave = (e) ->
    window.autosave_timer ||= setTimeout( autosave, 1000 )

  raiseChangesFlag = ->
    window.changesUnsaved = true

  debounceTime = 20000
  $(document).debounce "change", ".js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='text'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='number'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='url'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='tel'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "change", "textarea.js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "focusout", ".js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag

  updateUploadListVisiblity = (list, button, max) ->
    list_elements = list.find("li")
    count = list_elements.length
    wrapper = button.closest('div.js-upload-wrapper')

    if count > 0
      list.removeClass("visuallyhidden")

    if !max || count < max
      button.each ->
        $(this).removeClass("visuallyhidden")

    else
      button.each ->
        $(this).addClass("visuallyhidden")

  reindexUploadListInputs = (list) ->
    idx = 0
    list.find("li").each (i, li) ->
      process_input = (j, input_el) ->
        name = $(input_el).attr("name")
        match = /([^\[]+)\[([^\]]+)\]\[([0-9]*)\](.*)/.exec name
        if match
          $(input_el).attr("name", "#{match[1]}[#{match[2]}][#{idx}]#{match[4]}")

      $(li).find("input").each process_input
      $(li).find("textarea").each process_input
      idx++

  appendRemoveLinkForWebsiteLink = (div) ->
    remove_link = $("<a>").addClass("remove-link govuk-button govuk-button--warning remove-website").prop("href", "#").text("Remove")
    div.append(remove_link)

  appendRemoveLinkForAttachment = (div, wrapper, data) ->
    attachment_id = data.result['id']
    form_answer_id = data.result['form_answer_id']
    list_namespace = wrapper.attr("data-list-namespace")
    destroy_url = "/form/form_answers/" + form_answer_id + "/" + list_namespace + "/" + attachment_id

    remove_link = $("<a>").addClass("remove-link govuk-button govuk-button--warning")
                          .prop("href", destroy_url)
                          .attr("data-method", "delete")
                          .attr("data-remote", "true")
                          .text("Remove")
    div.append(remove_link)

  govuk_buttons = $( ".website-document-btns" )

  $('.js-file-upload').each (idx, el) ->
    form = $(el).closest('form')
    attachments_url = form.data 'attachments-url'
    $el = $(el)

    wrapper = $el.closest('div.js-upload-wrapper')
    button = wrapper.find(".js-button-add")
    list = wrapper.find('.js-uploaded-list')

    max = wrapper.data('max-attachments')
    name = wrapper.data('name')
    form_name = wrapper.data('form-name')
    needs_description = !!wrapper.data('description')
    has_filename = !!wrapper.data('filename')
    is_link = !!$el.data('add-link')

    govuk_button = $(el).closest('.govuk-button')

    #  Searching for inputs only excludes 'Add website address' button
    if $(el).is("input")
      $el.on "focus", ->
        button.addClass("onfocus")
        govuk_button.removeClass('govuk-button govuk-button--secondary')
        govuk_button.addClass('upload-focus')

      $el.on "blur", ->
        button.removeClass("onfocus")
        govuk_button.addClass('govuk-button govuk-button--secondary')
        govuk_button.removeClass('upload-focus')

    progress_all = (e, data) ->
      # TODO

    upload_started = (e, data) ->
      # Show `Uploading...`
      govuk_button.addClass("visuallyhidden")
      new_el = $("<li class='js-uploading'>")
      div = $("<div>")
      uid = '_' + Math.random().toString(36).substr(2, 9);
      label = $("<label class='govuk-label' for='#{uid}'>").text("Uploading...")
      div.append(label)
      new_el.append(div)
      list.append(new_el)
      list.removeClass("visuallyhidden")
      wrapper.removeClass("govuk-form-group--error")
      wrapper.find(".govuk-error-message").empty()

    success_or_error = (e, data) ->
      errors = data.result.errors

      if errors
        failed(errors.toString())
      else
        upload_done(e, data)

    failed = (error_message) ->
      if error_message
        wrapper.addClass("govuk-form-group--error")
        wrapper.find(".govuk-error-message").html(error_message)

      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.removeClass("visuallyhidden")
      govuk_button.removeClass("visuallyhidden")

    upload_done = (e, data, link) ->
      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.addClass("visuallyhidden")
      wrapper.removeClass("govuk-form-group--error")
      wrapper.find(".govuk-error-message").empty()

      # Show new upload
      new_el = $("<li>")

      if link
        div = $("<div>")
        uid = '_' + Math.random().toString(36).substr(2, 9);
        label = $("<label class='govuk-label' for='#{uid}'>").text('Website address')
        input = $("<input class=\"govuk-input js-trigger-autosave\" type=\"text\" id='#{uid}'>").prop('name', "#{form_name}[#{name}][][link]")
        label.append("<br/>")
        label.append(input)
        appendRemoveLinkForWebsiteLink(div)
        updateUploadListVisiblity(list, govuk_buttons, max)
        div.append(label)
        new_el.append(div)
      else
        new_el.addClass("js-file-uploaded")

        if has_filename
          filename = wrapper.data('filename')
        else
          if data.result['original_filename']
            filename = data.result['original_filename']
          else
            filename = "File uploaded"
        div = $("<div><p class='govuk-body'>#{filename}</p></div>")

        hidden_input = $("<input type='hidden' name='#{form_name}[#{name}][][file]' value='#{data.result['id']}' />")

        div.append(hidden_input)
        new_el.append(div)
        appendRemoveLinkForAttachment(div, wrapper, data)

      if needs_description
        desc_div = $("<div>")
        unique_name = "#{form_name}[#{name}][][description]"
        label = ($("<label class='govuk-label'>").text("Description").attr("for", unique_name))
        label.append($("<textarea class='govuk-textarea js-char-count js-trigger-autosave' rows='2' maxlength='600' data-word-max='100'>")
             .attr("name", unique_name)
             .attr("id", unique_name))
        desc_div.append(label)
        new_el.append(desc_div)

      list.append(new_el)
      new_el.find("textarea").val("")
      new_el.find('.js-char-count').charcount()
      list.removeClass('visuallyhidden')
      updateUploadListVisiblity(list, govuk_button, max)
      updateUploadListVisiblity(list, govuk_buttons, max)
      reindexUploadListInputs(list)
      new_el.find('input,textarea,select').filter(':visible').first().focus()

    updateUploadListVisiblity(list, govuk_buttons, max)

    if is_link
      $el.click (e) ->
        e.preventDefault()
        if !$(this).hasClass("read-only")
          upload_done(null, null, true)
        false
    else
      $el.fileupload(
        url: attachments_url + ".json"
        forceIframeTransport: true
        dataType: 'json'
        formData: [
          {
            name: "authenticity_token",
            value: $("meta[name='csrf-token']").attr("content")
          },
          {
            name: "question_key",
            value: $el.data("question-key")
          }
        ]
        progressall: progress_all
        send: upload_started
        always: success_or_error
      )

  $(document).on "click", ".js-upload-wrapper .remove-link", (e) ->
    e.preventDefault()

    if !$(this).hasClass("read-only")
      li = $(this).closest 'li'
      list = li.closest(".js-uploaded-list")
      wrapper = list.closest(".js-upload-wrapper")
      button = wrapper.find(".button-add")
      max = wrapper.data('max-attachments')

      li.remove()
      updateUploadListVisiblity(list, button, max)
      reindexUploadListInputs(list)
      triggerAutosave()
      false

  # Show current holder info when they are a current holder on basic eligibility current holder question
  if $(".eligibility_current_holder").length > 0
    $(".eligibility_current_holder input").change () ->
      if $(this).val() == "true"
        $("#current-holder-info").removeClass("visuallyhidden")
      else
        $("#current-holder-info").addClass("visuallyhidden")

  # Show innovation amount info when the amount is greater than 1 on innovation eligibility
  if $(".innovative_amount_input").length > 0
    $(".innovative_amount_input").bind "propertychange change click keyup input paste", ->
      if $(this).val() > 1
        $("#innovative-amount-info").removeClass("visuallyhidden")
      else
        $("#innovative-amount-info").addClass("visuallyhidden")
  # show ineligible message when option D is selected on PO eligibility
  if $(".promoting_opportunity_involvement_input").length > 0
    $(".promoting_opportunity_involvement_input").bind "propertychange change click keyup input paste", ->
      if $(this).val() == "D. We are an organisation whose core activity is to improve social mobility, and we are applying for this award on the basis of our core activity."
        $("#promoting_opportunity_involvement_warning").removeClass("visuallyhidden")
      else
        $("#promoting_opportunity_involvement_warning").addClass("visuallyhidden")

  # Show trade org fulfilled info when checked yes
  trade_org_q = ".question-organisation-fulfill-above-exceptions"
  if $(trade_org_q).length > 0
    $("#{trade_org_q} input[type='radio']").bind "propertychange change click keyup input paste", ->
      radio_val = $("#{trade_org_q} input[type='radio']:checked").val()
      if radio_val == "yes"
        $("#trade-org-fulfilled-info").removeClass("visuallyhidden")
      else
        $("#trade-org-fulfilled-info").addClass("visuallyhidden")

  trade_eligibility_not_eligible_message = (year_where_can_be_eligible) ->
    year_where_can_be_awarded = year_where_can_be_eligible + 1

    "<p>Unfortunately, you cannot apply for the International Trade Award this year.</p>
     <p>If your international trade continues to result in outstanding year-on-year growth, you can apply again in " +
     year_where_can_be_eligible +
     " for an award to be given in " +
     year_where_can_be_awarded +
     " (on Outstanding Short-Term Growth over a 3 years basis); providing you include two new years of trading results in your application.</p>"

  # Show trade awarded info if it isn't 2010 (lowest year)
  if $(".trade-awarded-input").length > 0
    $(document).on "change", ".trade-awarded-input", (e) ->
      lowest_year = "9999"
      last_year = "2000"
      taInfo = $("#trade-awarded-info")
      lyInfo = $("#trade-awarded-last-year-info")

      $(".trade-awarded-input option").each ->
        this_year = $(this).attr("value")
        if this_year != ""
          if parseInt(lowest_year) > parseInt(this_year)
            lowest_year = this_year
          if parseInt(last_year) < parseInt(this_year)
            last_year = this_year

      last_year_int = parseInt(last_year)
      value_int = parseInt($(this).val())
      not_eligible_years = [last_year_int]
      not_eligible_block = lyInfo.find(".application-notice")

      if ($.inArray(value_int, not_eligible_years) >= 0)
        not_eligible_block.html(trade_eligibility_not_eligible_message(value_int + 1))

        lyInfo.removeClass("visuallyhidden")
        taInfo.addClass("visuallyhidden")
      else if $(this).val().length > 1 && value_int > (last_year - 5) && value_int < last_year_int
        taInfo.removeClass("visuallyhidden")
        lyInfo.addClass("visuallyhidden")
      else
        taInfo.addClass("visuallyhidden")
        lyInfo.addClass("visuallyhidden")

      if $(this).val().length > 0 && value_int < last_year_int
        $(".eligibility_qae_for_trade_award_year").removeClass("field-with-errors")
                                                  .find("span.error").remove();

  $(".trade-awarded-input").trigger "change"

  # Show the eligibility failure contact message
  if $("#basic-eligibility-failure-submit").length > 0
    $(document).on "click", "#basic-eligibility-failure-submit", (e) ->
      e.preventDefault()
      if $(this).closest("form").find("input:checked").val()
        $("#basic-eligibility-failure-answered").addClass("visuallyhidden")
        $("#basic-eligibility-failure-show").removeClass("visuallyhidden")

  # Change your eligibility answers for award eligibility
  if $(".award-finish-previous-answers").length > 0
    $(document).on "click", ".award-finish-previous-answers a", (e) ->
      e.preventDefault()
      $("#form_eligibility_show").addClass("visuallyhidden")
      $("#form_eligibility_questions").removeClass("visuallyhidden")

  # Updates labels and ids on trade product fields
  resetTradeProductIndexes = (question) ->
    if question.hasClass("js-by-trade-goods-and-services-amount")
      list_count = question.find("li").length
      question.find("li").each (index) ->
        idx = index + 1
        id = "form[trade_goods_and_services_explanations"
        name = "form[trade_goods_and_services_explanations]"
        products = $(this).find(".trade-good-product")
        percentages = $(this).find(".trade-good-percentage")
        word_limit = products.find("textarea").attr("data-word-max")
        remove_link = $(this).find(".js-remove-link")

        products.find("label").get(0).innerText = "Product or service description " + idx + " (word limit: #{word_limit}):"
        products.find("label").attr("for", id + "_desc_short_#{idx}]" )
        products.find("textarea").attr({
          "id": id + "_desc_short_#{idx}]",
          "name": name + "[#{idx}][desc_short]"
        })
        percentages.find("label").attr("for", id + "_total_overseas_trade_#{idx}]")
        percentages.find("input").attr({
          "id": id + "_total_overseas_trade_#{idx}]",
          "name": name + "[#{idx}][total_overseas_trade]"
        })
        remove_link.attr("aria-label", "Remove " + ordinal(idx) + " product")
        if list_count <= 1
          remove_link.addClass("visuallyhidden")
        else
          remove_link.removeClass("visuallyhidden")

  # Clicking `+ Add` on certain questions add fields
  $(document).on "click", ".question-block .js-button-add", (e) ->
    e.preventDefault()
    e.stopPropagation()

    if !$(this).hasClass("read-only")
      entity = $(this).data("entity")
      question = $(this).closest(".question-block")
      add_eg = question.find(".js-add-example").html()

      if question.find(".list-add").length > 0
        can_add = true

        # Are there add limits
        add_limit_attr = question.find(".list-add").attr("data-add-limit")

        li_size = question.find(".list-add > li:visible").length

        if ((typeof(add_limit_attr) != typeof(undefined)) && add_limit_attr != false)

          if li_size >= add_limit_attr
            can_add = false

          if li_size + 1 >= add_limit_attr
            question.find(".js-button-add").addClass("visuallyhidden")


        if can_add
          add_eg = add_eg.replace(/((\w+|_)\[(\w+|_)\]\[)(\d+)\]/g, "$1#{li_size}]")
          add_eg = add_eg.replace(/((\w+|_)\[(\w+|_)\]\[)(\{index\})\]/g, "$1#{li_size}]")

          question.find(".list-add").append("<li class='js-add-example if-no-js-hide js-list-item'>#{add_eg}</li>")
          question.find(".list-add").find("li:last-child input").prop("disabled", false)

          idx = question.find(".list-add").find("> li").length

          # update labels and aria-labels on new product fields
          resetTradeProductIndexes(question.find(".list-add"))

          question.find(".list-add").find("li:last-child .remove-link").attr("aria-label", "Remove " + ordinal(idx) + " " + entity)
          clear_example = question.find(".list-add").attr("data-need-to-clear-example")
          if (typeof(clear_example) != typeof(undefined) && clear_example != false)
            question.find(".list-add li.js-list-item:last .govuk-error-message").empty()
            clearFormElements(question.find(".list-add li.js-list-item:last"))

          # If .js-add-example has file field (like in SupportLetters)
          # Then we also need to clean filename and init fileupload
          example_has_file_field = question.find(".list-add").attr("data-example-has-file-field")
          if (typeof(example_has_file_field) != typeof(undefined) && example_has_file_field != false)
            SupportLetters.new_item_init(question.find(".list-add li.js-list-item:last"))
          else
            question.find(".list-add").find("li:last-child").find("input,textarea,select").filter(':visible').first().focus()

          # charcount needs to be reinitialized
          if (textareas = question.find(".list-add > li:last .js-char-count")).length
            textareas.removeCharcountElements()
            textareas.charcount()

          # remove the default reached class to allow removing again
          questionAddDefaultReached(question.find(".list-add"))
          window.FormValidation.validateStep()
          triggerAutosave()

  # Removing these added fields
  $(document).on "click", ".govuk-form-group .list-add .js-remove-link", (e) ->
    e.preventDefault()

    if !$(this).hasClass("read-only")
      parent = $(this).closest(".list-add")
      parent_ul = $(this).closest("ul")
      $(this).closest(".govuk-form-group")
             .find(".js-button-add")
             .removeClass("visuallyhidden")

      if $(this).hasClass("remove-supporter")

        url = $(this).attr("href")
        $.ajax
          url: url
          type: 'DELETE'

      if $(this).data("remove-association")
        $(this).closest("li").addClass("visuallyhidden")
        $("input.remove", $(this).closest("li")).val("1")
      else
        $(this).closest("li").remove()

      resetTradeProductIndexes(parent)

      questionAddDefaultReached(parent_ul)
      window.FormValidation.validateStep()
      triggerAutosave()

  questionAddDefaultReached = (ul) ->
    if ul.length > 0
      attr = ul.attr("data-default")
      hasAttrDefault = false

      if typeof attr != typeof undefined && attr != false
        hasAttrDefault = true

      if hasAttrDefault
        ul.removeClass("js-default-reached")
        if ul.find("li").not(".hidden").length <= attr
          ul.addClass("js-default-reached")

  $(".list-add").each ->
    questionAddDefaultReached($(this))

  # Disable copying in input fields
  $('.js-disable-copy').bind "cut copy contextmenu", (e) ->
    e.preventDefault()

  # Change the entry period text dependion on entry period chosen
  # 2 or 5 years for Innovation and Sustainable development
  # 3 or 6 years for International Trade
  replaceEntryPeriodText = () ->
    new_text = ""
    switch $(".js-entry-period input:checked").val()
      when "2 to 4"
        new_text = "two"
      when "5 plus"
        new_text = "five"
      when "3 to 5"
        new_text = "three"
      when "6 plus"
        new_text = "six"
    $(".js-entry-period-subtext").each () ->
      $(this).text(new_text)
  if $(".js-entry-period input:checked").length > 0
    replaceEntryPeriodText()

  $(".js-entry-period input").change () ->
    replaceEntryPeriodText()
    FormValidation.validateStep("step-company-information")

  # Auto tab on date input entry
  #$(".date-input input").on 'keyup', (e) ->
  #  this_label = $(this).closest("label")
  #  new_input = ""
  #  # if it isn't the year input accept 2 numbers (48-57) or moving right (39)
  #  if this_label.index() != $(this).closest(".date-input").find("label:last-child").index()
  #    if (e.which >= 48 && e.which <= 57) || (e.which >= 96 && e.which <= 105) || e.keyCode == 39
  #      if $(this).val().length == 2
  #        # focus on the next input
  #        new_input = this_label.next().find("input")
  #  # if it isn't the day input you can go backwards by backspacing (8) or moving left (37)
  #  if this_label.index() != $(this).closest(".date-input").find("label:first-child").index()
  #    if e.keyCode == 8 || e.keyCode == 37
  #      if $(this).val().length == 0
  #        # focus on the next input
  #        new_input = this_label.prev().find("input")
  #  if new_input != ""
  #    new_input_text = new_input.val()
  #    new_input.val("")
  #    new_input.focus()
  #    new_input.val(new_input_text)

  # only accept numbers(48-47), backspace(8), tab(9), cursor keys left(37) and right(39) and enter for submitting
  $(".govuk-date-input input").on 'keypress keydown keyup', (e) ->
    if !((e.which >= 48 && e.which <= 57) || (e.which >= 96 && e.which <= 105) || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 13)
      e.preventDefault()
      return false

  # Remove alerts from registration page as soon as user starts typing
  $(".page-devise input").on 'keypress keydown keyup change', () ->
    $(this).closest(".field-with-errors").removeClass("field-with-errors")
    if $(this).closest(".form-inputs-group").length > 0
      $(this).closest(".form-inputs-group").find(".error").remove()
    else
      $(this).closest(".question-body").find(".error").remove()

  # Disable using enter key to submit on the form
  $("form .steps-progress-content").on 'keypress', (e) ->
    if e.keyCode == 13
      target = $(e.target)
      if !target.is("textarea") && !target.is(":button,:submit")
        $(this).find(":input:visible:not([disabled],[readonly]), a").each () ->
          return false
        return false

  # Dropdowns for nav
  $(document).on "click", ".dropdown > a", (e) ->
    e.preventDefault()
    $(this).closest(".dropdown").toggleClass("dropdown-open")
  $(document).on 'click', (e) ->
    if !$(e.target).closest('.dropdown').length
      $(".dropdown.dropdown-open").removeClass("dropdown-open")

  # Dropdowns for sidebar
  $(document).on "click", ".steps-progress-bar .dropdown-toggle", (e) ->
    e.preventDefault()
    $(this).closest("span").toggleClass("open")

  OptionsWithPreselectedConditionsQuestion.init()
  WonInternationalTradeAwardQuestion.init()
  ongoingDateDuration()
  SupportLetters.init()
  AuditCertificatesUpload.init()
  ActualFiguresUpload.init()
  VatReturnsUpload.init()

  if $(".js-press-comment-correct input:checked").val() == "true"
    $(".js-press-comment-feeback").addClass("section-confirmed")
  $(".js-press-comment-correct input").change ->
    $(".js-press-comment-feeback").removeClass("section-confirmed")
    if $(".js-press-comment-correct input:checked").val() == "true"
      $(".js-press-comment-feeback").addClass("section-confirmed")

  #
  # Init WYSYWYG editor for QAE Form textareas - begin
  #

  if $('.js-ckeditor').length > 0

    CKEDITOR.plugins.addExternal( 'wordcount', '/ckeditor/plugins/notification/plugin.js' );
    CKEDITOR.plugins.addExternal( 'wordcount', '/ckeditor/plugins/wordcount/plugin.js' );

    $('.js-ckeditor').each (index) ->
      group = $(this).closest(".govuk-form-group")

      spacer = $("<div class='js-ckeditor-spacer'></div>")
      spacer.insertAfter($(this).parent().find(".hint"))

      CKEDITOR.replace this,
        title: group.find('label').first().text(),
        toolbar: 'mini'
        language: 'en'
        toolbar_mini: [
          {name: 'p1', items: ["Cut", "Copy", "PasteText", "-", "Undo", "Redo"]},
          {name: 'p2', items: ["Bold", "Italic",  "-", "RemoveFormat"]},
          {name: 'p3', items: ["NumberedList", "BulletedList", "-", "Outdent", "Indent", "-", 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock']}
        ]
        toolbar: "mini";
        extraPlugins: 'wordcount'

        wordcount: {
          showParagraphs: false,
          showWordCount: true
        }

        removePlugins: 'link,elementspath,contextmenu,liststyle,tabletools,tableselection'
        disableNativeSpellChecker: false

        allowedContent: 'h1 h2 h3 blockquote p ul ol li em i strong b i br'
        height: 200
        wordcount:
          maxWordCount: $(this).data('word-max')

      CKEDITOR.on 'instanceCreated', (event) ->
        editor = event.editor
        element = editor.element


      CKEDITOR.on 'instanceReady', (event) ->
        target_id = event.editor.name

        spinner = group.find(".js-ckeditor-spinner-block")
        spinner.addClass('govuk-!-display-none')

    for i of CKEDITOR.instances
      instance = CKEDITOR.instances[i]

      instance.on 'change', (event) ->
        target_id = event.editor.name
        element = CKEDITOR.instances[target_id]

        element.updateElement()
        raiseChangesFlag()

        $("#" + target_id).trigger("change")

        return

    TextareaCkeditorIeCallback.init()

  #
  # Init WYSYWYG editor for QAE Form textareas - end
  #
