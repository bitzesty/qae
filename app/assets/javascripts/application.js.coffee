#= require jquery
#= require jquery_ujs
#= require jquery.iframe-transport
#= require jquery.fileupload
#= require select2.full.min
#= require Countable
#= require moment.min
#= require core
#= require vendor/polyfills/bind
#= require govuk/selection-buttons
#= require libs/suchi/isOld.js
#= require govuk_toolkit
#= require mobile
#= require browser-check
#= require vendor/zxcvbn
#= require vendor/jquery-debounce
#= require_tree ./frontend

jQuery ->
  $("html").removeClass("no-js").addClass("js")

  # initialize Select dropdowns, if needed
  window.Select2Dropdowns.init()

  # This is a very primitive way of testing.
  # Should be refactored once forms stabilize.
  #
  # TODO: Refactor this later on
  validate = ->
    window.FormValidation.validate()

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
    $(this).closest(".hidden-hint").toggleClass("show-hint")

  $(document).on "click", ".hidden-link-for", (e) ->
    e.preventDefault()
    link_href = $(this).attr("href").substr(1)
    hidden_link = $(this).closest(".question-block").find("."+link_href)
    hidden_link.toggleClass("show-hint")

  # Remove validation error after changing the value
  $(".question-block input, .question-block select, .question-block textarea").change () ->
    if $("body").hasClass("tried-submitting")
      if $(this).closest(".question-financial").size() > 0
        if $(this).closest("label").find(".errors-container li").size() > 0
          $(this).closest("label").find(".errors-container").empty()
      else
        if $(this).closest(".question-block").find(".errors-container li").size() > 0
          $(this).closest(".question-block").find(".errors-container").empty()
      $(this).closest(".question-has-errors").removeClass("question-has-errors")
  $(".supporters-list input").change ->
    $(this).closest("label").find(".errors-container").empty()
    $(this).closest(".question-has-errors").removeClass("question-has-errors")

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
      if $(this).attr('data-value') == answerVal || ($(this).attr('data-value') == "true" && (answerVal != 'false' && answerVal != false)) || ($(this).attr('data-type') == "in_clause_collection" && $(this).attr('data-value') <= answerVal)
        if clicked || (!clicked && input.attr('type') == 'radio' && input.is(':checked')) || (!clicked && input.attr('type') != 'radio')
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

  # Get the latest financial year date from input
  updateYearEndInput = () ->
    fy_latest_changed_input = $(".js-financial-year-changed-dates .fy-latest .date-input")
    fy_latest_changed_input.find("input").removeAttr("disabled")

    fy_day = $('.js-financial-year-latest .js-fy-day select').val()
    fy_month = $('.js-financial-year-latest .js-fy-month select').val()
    fy_year = new Date().getFullYear()

    # Conditional latest year
    # If from October to December -> then previous year
    # If from January to September -> then current year
    if fy_month >= 10
      fy_year = parseInt(fy_year) - 1

    # Updates the latest changed financial year input
    fy_latest_changed_input.find("input.js-fy-day").val(fy_day)
    fy_latest_changed_input.find("input.js-fy-month").val(fy_month)

    # Auto fill the year for previous years
    $(".js-financial-year-changed-dates .js-fy-entries").each ->
      parent_fy = $(this).parent().find(".js-fy-entries")
      this_fy_year = fy_year - (parent_fy.size() - parent_fy.index($(this)) - 1)
      $(this).find("input.js-fy-year").val(this_fy_year).attr("disabled", "disabled")
    fy_latest_changed_input.find("input").attr("disabled", "disabled")
    $(".js-financial-year-changed-dates").attr("data-year", fy_year)

    updateYearEnd()

  # Update the financial year labels
  updateYearEnd = () ->
    $(".js-financial-conditional .js-year-end").removeClass("show-default")
    if $(".js-financial-year-change input:checked").val() == "no"
      # Year end hasn't changed, auto select the year
      fy_latest_changed_input = $(".js-financial-year")
      fy_latest_day = fy_latest_changed_input.find(".js-fy-day select").val()
      fy_latest_month = fy_latest_changed_input.find(".js-fy-month select").val()
      fy_latest_year = $(".js-financial-year-changed-dates").attr("data-year")

      if !fy_latest_day || !fy_latest_month || !fy_latest_year
        $(".js-year-end").addClass("show-default")
      else
        $(".js-year-end").each ->
          year = parseInt(fy_latest_year) + parseInt($(this).attr("data-year").substr(0, 1)) - parseInt($(this).attr("data-year").substr(-1, 1))
          pre_text = "Year ending in"
          if $(this).closest(".question-block").hasClass("total-net-assets")
            pre_text = "As at"
          $(this).find(".js-year-text").text("#{pre_text} #{fy_latest_day}/#{fy_latest_month}/#{year}")
    else
      # Year has changed, use what they've inputted
      $(".js-financial-conditional > .js-conditional-question").each ->
        all_years_value = true
        $(this).find(".js-year-end").each ->
          fy_input = $(".js-financial-year-changed-dates .js-year-end[data-year='#{$(this).attr("data-year")}']").closest(".js-fy-entries").find(".date-input")
          fy_day = fy_input.find(".js-fy-day").val()
          fy_month = fy_input.find(".js-fy-month").val()
          fy_year = fy_input.find(".js-fy-year").val()
          if !fy_day || !fy_month || !fy_year
            all_years_value = false
        if !all_years_value
          $(this).find(".js-year-end").addClass("show-default")
        else
          $(this).find(".js-year-end").each ->
            fy_input = $(".js-financial-year-changed-dates .js-year-end[data-year='#{$(this).attr("data-year")}']").closest(".js-fy-entries").find(".date-input")
            fy_day = fy_input.find(".js-fy-day").val()
            fy_month = fy_input.find(".js-fy-month").val()
            fy_year = fy_input.find(".js-fy-year").val()
            pre_text = "Year ending in"
            if $(this).closest(".question-block").hasClass("total-net-assets")
              pre_text = "As at"
            $(this).find(".js-year-text").text("#{pre_text} #{fy_day}/#{fy_month}/#{fy_year}")

  updateYearEndInput()
  $(".js-financial-year-changed-dates input, .js-financial-year select").change () ->
    updateYearEndInput()
  $(".js-financial-year-latest").closest(".question-block").next().find("input").change () ->
    updateYearEnd()

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

  # Show/hide the correct step/page for the award form
  showAwardStep = (step) ->
    $("body").removeClass("show-error-page")

    $(".js-step-condition.step-current").removeClass("step-current")

    window.location.hash = "##{step.substr(5)}"
    $(".js-step-condition[data-step='#{step}']").addClass("step-current")

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
    if $(".js-step-condition[data-step='step-#{step}']").size() > 0
      showAwardStep("step-#{step}")
      # Resize textareas that were previously hidden
      resetResizeTextarea()
    else
      window.location.hash = $(".js-step-condition.step-current").attr("data-step").substr(5)

      # Setting current_step_id to form as we updating only current section form_data (not whole form)
      $("#current_step_id").val(step)

  changesUnsaved = false

  $(".qae-form").on "submit", (e) ->
    if changesUnsaved
      e.preventDefault()
      e.stopPropagation()

      autosave ->
        $(".qae-form").trigger("submit")

  $(document).on "click", ".js-step-link", (e) ->
    e.preventDefault()
    if !$(this).hasClass("step-current")
      autosave()

      current = $(this).attr("data-step")
      if $(this).hasClass "js-next-link"
        if $("body").hasClass("tried-submitting")
          validate()
      showAwardStep(current)
      # Scroll to top
      $("html, body").animate(
        scrollTop: 0
      , 0)
      # Resize textareas that were previously hidden
      resetResizeTextarea()

  $(document).on "click", ".save-quit-link a", (e) ->
    if changesUnsaved
      e.preventDefault()
      e.stopPropagation()

      link = $(@).attr("href")

      $(@).text("Saving...")

      autosave ->
        window.location.href = link

  autosave = (callback) ->
    window.autosave_timer = null
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
          changesUnsaved = false
          if callback isnt undefined
            callback()
      })
    #TODO: indicators, error handlers?

  loseChangesMessage = "You have unsaved changes! If you leave the page now, some answers will be lost. Stay on the page for a minute in order for everything to be saved or use the buttons at the bottom of the page."

  window.onbeforeunload = ->
    if !$(".page-read-only-form").length
      if changesUnsaved then loseChangesMessage else undefined

  if window.addEventListener isnt undefined
    window.addEventListener "beforeunload", (e) ->
      return undefined unless changesUnsaved

      e.returnValue = loseChangesMessage
      loseChangesMessage

  triggerAutosave = (e) ->
    window.autosave_timer ||= setTimeout( autosave, 1000 )

  raiseChangesFlag = ->
    changesUnsaved = true

  debounceTime = 20000
  $(document).debounce "change", ".js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='text'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='number'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='url'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "input[type='tel'].js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag
  $(document).debounce "keyup", "textarea.js-trigger-autosave", triggerAutosave, debounceTime, raiseChangesFlag

  updateUploadListVisiblity = (list, button, max) ->
    list_elements = list.find("li")
    count = list_elements.length
    wrapper = button.closest('div.js-upload-wrapper')

    if count > 0
      list.removeClass("visuallyhidden")

    if !max || count < max
      button.removeClass("visuallyhidden")
    else
      button.addClass("visuallyhidden")

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
    remove_link = $("<a>").addClass("remove-link").prop("href", "#").text("Remove")
    div.append(remove_link)

  appendRemoveLinkForAttachment = (div, wrapper, data) ->
    attachment_id = data.result['id']
    form_answer_id = data.result['form_answer_id']
    list_namespace = wrapper.attr("data-list-namespace")
    destroy_url = "/form/form_answers/" + form_answer_id + "/" + list_namespace + "/" + attachment_id

    remove_link = $("<a>").addClass("remove-link")
                          .prop("href", destroy_url)
                          .attr("data-method", "delete")
                          .attr("data-remote", "true")
                          .text("Remove")
    div.append(remove_link)

  $('.js-file-upload').each (idx, el) ->
    form = $(el).closest('form')
    attachments_url = form.data 'attachments-url'
    $el = $(el)

    wrapper = $el.closest('div.js-upload-wrapper')
    button = wrapper.find(".button-add")
    list = wrapper.find('.js-uploaded-list')

    max = wrapper.data('max-attachments')
    name = wrapper.data('name')
    form_name = wrapper.data('form-name')
    needs_description = !!wrapper.data('description')
    has_filename = !!wrapper.data('filename')
    is_link = !!$el.data('add-link')

    progress_all = (e, data) ->
      # TODO

    upload_started = (e, data) ->
      # Show `Uploading...`
      button.addClass("visuallyhidden")
      new_el = $("<li class='js-uploading'>")
      div = $("<div>")
      label = $("<label>").text("Uploading...")
      div.append(label)
      new_el.append(div)
      list.append(new_el)
      list.removeClass("visuallyhidden")
      wrapper.removeClass("question-has-errors")
      wrapper.find(".errors-container").empty()

    success_or_error = (e, data) ->
      errors = data.result.errors

      if errors
        failed(errors.toString())
      else
        upload_done(e, data)

    failed = (error_message) ->
      if error_message
        wrapper.addClass("question-has-errors")
        wrapper.find(".errors-container").html("<li>" + error_message + "</li>")

      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.removeClass("visuallyhidden")
      button.removeClass("visuallyhidden")

    upload_done = (e, data, link) ->
      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.addClass("visuallyhidden")
      wrapper.removeClass("question-has-errors")
      wrapper.find(".errors-container").empty()

      # Show new upload
      new_el = $("<li>")

      if link
        div = $("<div>")
        label = $("<label>").text('Website address')
        input = $("<input class=\"medium js-trigger-autosave\" type=\"text\">").
          prop('name', "#{form_name}[#{name}][][link]")
        label.append(input)
        appendRemoveLinkForWebsiteLink(div)
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
        div = $("<div>").text(filename)

        hidden_input = $("<input type='hidden' name='#{form_name}[#{name}][][file]' value='#{data.result['id']}' />")

        div.append(hidden_input)
        appendRemoveLinkForAttachment(div, wrapper, data)
        new_el.append(div)

      if needs_description
        desc_div = $("<div>")
        unique_name = "#{form_name}[#{name}][][description]"
        label = ($("<label>").text("Description").attr("for", unique_name))
        label.append($("<textarea class='js-char-count js-trigger-autosave' rows='2' maxlength='600' data-word-max='100'>")
             .attr("name", unique_name)
             .attr("id", unique_name))
        desc_div.append(label)
        new_el.append(desc_div)

      list.append(new_el)
      new_el.find("textarea").val("")
      new_el.find('.js-char-count').charcount()
      list.removeClass('visuallyhidden')
      updateUploadListVisiblity(list, button, max)
      reindexUploadListInputs(list)

    updateUploadListVisiblity(list, button, max)

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
  if $(".eligibility_current_holder").size() > 0
    $(".eligibility_current_holder input").change () ->
      if $(this).val() == "true"
        $("#current-holder-info").removeClass("visuallyhidden")
      else
        $("#current-holder-info").addClass("visuallyhidden")

  # Show innovation amount info when the amount is greater than 1 on innovation eligibility
  if $(".innovative_amount_input").size() > 0
    $(".innovative_amount_input").bind "propertychange change click keyup input paste", ->
      if $(this).val() > 1
        $("#innovative-amount-info").removeClass("visuallyhidden")
      else
        $("#innovative-amount-info").addClass("visuallyhidden")

  # Show trade org fulfilled info when checked yes
  trade_org_q = ".question-organisation-fulfill-above-exceptions"
  if $(trade_org_q).size() > 0
    $("#{trade_org_q} input[type='radio']").bind "propertychange change click keyup input paste", ->
      radio_val = $("#{trade_org_q} input[type='radio']:checked").val()
      if radio_val == "yes"
        $("#trade-org-fulfilled-info").removeClass("visuallyhidden")
      else
        $("#trade-org-fulfilled-info").addClass("visuallyhidden")

  # Show trade awarded info if it isn't 2010 (lowest year)
  if $(".trade-awarded-input").size() > 0
    $(".trade-awarded-input").bind "change", ->
      lowest_year = "9999"
      $(".trade-awarded-input option").each ->
        if $(this).attr("value") != ""
          if parseInt(lowest_year) > parseInt($(this).attr("value"))
            lowest_year = $(this).attr("value")
      if $(this).val().indexOf(lowest_year) == -1
        $("#trade-awarded-info").removeClass("visuallyhidden")
      else
        $("#trade-awarded-info").addClass("visuallyhidden")

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

    if !$(this).hasClass("read-only")
      question = $(this).closest(".question-block")
      add_eg = question.find(".js-add-example").html()

      if question.find(".list-add").size() > 0
        can_add = true

        # Are there add limits
        add_limit_attr = question.find(".list-add").attr("data-add-limit")

        li_size = question.find(".list-add > li:visible").size()

        if ((typeof(add_limit_attr) != typeof(undefined)) && add_limit_attr != false)

          if li_size >= add_limit_attr
            can_add = false

          if li_size + 1 >= add_limit_attr
            question.find(".js-button-add").addClass("visuallyhidden")

        if can_add
          add_eg = add_eg.replace(/((\w+|_)\[(\w+|_)\]\[)(\d+)\]/g, "$1#{li_size}]")
          add_eg = add_eg.replace(/((\w+|_)\[(\w+|_)\]\[)(\{index\})\]/g, "$1#{li_size}]")

          question.find(".list-add").append("<li class='js-add-example js-list-item'>#{add_eg}</li>")
          question.find(".list-add").find("li:last-child input").prop("disabled", false)
          clear_example = question.find(".list-add").attr("data-need-to-clear-example")
          if (typeof(clear_example) != typeof(undefined) && clear_example != false)
            question.find(".list-add li.js-list-item:last .errors-container").empty()
            clearFormElements(question.find(".list-add li.js-list-item:last"))

          # If .js-add-example has file field (like in SupportLetters)
          # Then we also need to clean filename and init fileupload
          example_has_file_field = question.find(".list-add").attr("data-example-has-file-field")
          if (typeof(example_has_file_field) != typeof(undefined) && example_has_file_field != false)
            SupportLetters.new_item_init(question.find(".list-add li.js-list-item:last"))

          # charcount needs to be reinitialized
          if (textareas = question.find(".list-add > li:last .js-char-count")).length
            textareas.removeCharcountElements()
            textareas.charcount()

          # remove the default reached class to allow removing again
          questionAddDefaultReached(question.find(".list-add"))

          triggerAutosave()

  # Removing these added fields
  $(document).on "click", ".question-group .list-add .js-remove-link", (e) ->
    e.preventDefault()
    if !$(this).hasClass("read-only")
      parent_ul = $(this).closest("ul")
      $(this).closest(".question-group")
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

      questionAddDefaultReached(parent_ul)
      triggerAutosave()

  questionAddDefaultReached = (ul) ->
    if ul.size() > 0
      attr = ul.attr("data-default")
      hasAttrDefault = false

      if typeof attr != typeof undefined && attr != false
        hasAttrDefault = true

      if hasAttrDefault
        ul.removeClass("js-default-reached")
        if ul.find("li").not(".hidden").size() <= attr
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
        new_text = 2
      when "5 plus"
        new_text = 5
      when "3 to 5"
        new_text = 3
      when "6 plus"
        new_text = 6
    $(".js-entry-period-subtext").each () ->
      $(this).text(new_text)
  if $(".js-entry-period input:checked").size() > 0
    replaceEntryPeriodText()
  $(".js-entry-period input").change () ->
    replaceEntryPeriodText()

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
  $(".date-input input").on 'keypress keydown keyup', (e) ->
    if !((e.which >= 48 && e.which <= 57) || (e.which >= 96 && e.which <= 105) || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 13)
      e.preventDefault()
      return false

  # Remove alerts from registration page as soon as user starts typing
  $(".page-devise input").on 'keypress keydown keyup change', () ->
    $(this).closest(".field-with-errors").removeClass("field-with-errors")
    if $(this).closest(".form-inputs-group").size() > 0
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
  ongoingDateDuration()
  SupportLetters.init()
  AuditCertificatesUpload.init()

  if $(".js-press-comment-correct input:checked").val() == "true"
    $(".js-press-comment-feeback").addClass("section-confirmed")
  $(".js-press-comment-correct input").change ->
    $(".js-press-comment-feeback").removeClass("section-confirmed")
    if $(".js-press-comment-correct input:checked").val() == "true"
      $(".js-press-comment-feeback").addClass("section-confirmed")
