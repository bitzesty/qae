ready = ->
  htmlDecode = (value) ->
    $("<div/>").html(value).text()

  changeRagStatus()
  editFormAnswerAutoUpdate()
  bindRags("#section-appraisal-form-primary .edit_assessor_assignment")
  bindRags("#section-appraisal-form-secondary .edit_assessor_assignment")
  bindRags("#section-appraisal-form-moderated .edit_assessor_assignment")
  bindRags("#section-case-summary-primary_case_summary .edit_assessor_assignment")
  bindRags("#section-case-summary-lead_case_summary .edit_assessor_assignment")

  handleCompanyDetailsForm()
  handleWinnersForm()
  handleReviewAuditCertificate()

  # Move the attach document button
  moveAttachDocumentButton = ->
    wrapper = $("#application-attachment-form")
    $(".attachment-link", wrapper).removeClass("if-js-hide")
    $(".attachment-link", wrapper).addClass("btn btn-default btn-block btn-attachment")
    $(".attachment-link", wrapper).prepend("<span class='btn-title'>Attach document</span>")
    $(".attachment-link", wrapper).prepend("<span class='glyphicon glyphicon-paperclip'></span>")
    $(".attachment-link", wrapper).prependTo("#new_form_answer_attachment")

  $("#new_review_audit_certificate").on "ajax:success", (e, data, status, xhr) ->
    $(this).find(".form-group").removeClass("form-edit")
    $(this).find(".form-edit-link").remove()
    $(".save-review-audit").remove()
    area = $(".audit-cert-description textarea")
    unless area.val()
      $(this).find(".form-value").html($("<p>No change necessary</p>"))
    else
      div = "<div><label>Changes made</label><p class='control-label'>#{area.val()}</p></div>"
      $(this).find(".form-value").html(div)
  $("#new_review_audit_certificate").on "click", ".save-review-audit", (e) ->
    e.preventDefault()
    $("#new_review_audit_certificate").submit()
  $(".edit-review-audit").on "click", (e) ->
    $(".save-review-audit").show()

  $(".section-applicant-status").on "click", "a", (e) ->
    e.preventDefault()
    state = $(this).data("state")
    form = $("#new_form_answer_state_transition")
    form.find("option[value='#{state}']").prop("selected", true)
    $(".section-applicant-status .dropdown-toggle").text($(this).data("label"))
    form.submit()
  $("#new_form_answer_state_transition").on "ajax:success", (e, data, status, xhr) ->
    $(".section-applicant-status .dropdown-menu").replaceWith(data)

  $(".section-applicant-users .edit_assessor_assignment select").select2()
  $("#new_assessor_assignment_collection select").select2()

  $(".section-applicant-users form").on "ajax:success", (e, data, status, xhr) ->
    form = $(this)
    form.find(".errors-holder").text("")
    form.closest(".form-group").removeClass("form-edit")
    formValueBox = form.closest(".form-group").find(".edit-value")
    formValue = form.find("select :selected").text()
    formValueBox.text(formValue)
  $(".section-applicant-users form").on "ajax:error", (e, data, status, xhr) ->
    form = $(this)
    errors = ""
    for k, error of data.responseJSON["errors"]
      errors += error

    form.find(".errors-holder").text(errors)

  $("#new_form_answer_attachment").on "fileuploadsubmit", (e, data) ->
    data.formData =
      authenticity_token: $("meta[name='csrf-token']").attr("content")
      format: "js"
      "form_answer_attachment[title]": $("#form_answer_attachment_title").val()
      "form_answer_attachment[restricted_to_admin]": $("#form_answer_attachment_restricted_to_admin").prop("checked")

  if $("html").hasClass("lte-ie7")
    $(".attachment-link", $("#application-attachment-form")).removeClass("if-js-hide")
  else
    do initializeFileUpload = ->
      $("#new_form_answer_attachment").fileupload
        autoUpload: false
        dataType: "html"
        forceIframeTransport: true
        add: (e, data) ->
          newForm = $("#new_form_answer_attachment")
          $(".attachment-title").val(data.files[0].name)
          newForm.closest(".sidebar-section").addClass("show-attachment-form")
          newForm.find(".btn-submit").focus().blur()
          newForm.find(".btn-submit").unbind("click").on "click", (e) ->
            e.preventDefault()
            data.submit()
        success: (result, textStatus, jqXHR) ->
          result = $($.parseHTML(result))
          $("#attachment-buffer").append(result.text())

          if $("#form-answer-attachment-valid", $("#attachment-buffer")).length
            $("#application-attachment-form").html(result.text())
            moveAttachDocumentButton()
            initializeFileUpload()
          else
            form = $("#new_form_answer_attachment")
            sidebarSection = form.closest(".sidebar-section")
            sidebarSection.find(".document-list .p-empty").addClass("visuallyhidden")
            sidebarSection.find(".document-list ul").append(result.text())
            sidebarSection.removeClass("show-attachment-form")
            $("#form_answer_attachment_title").val(null)
            $("#form_answer_attachment_restricted_to_admin").prop("checked", false)

          $("#attachment-buffer").empty()

    moveAttachDocumentButton()

  $(document).on "click", ".js-attachment-form .btn-cancel", (e) ->
    e.preventDefault()
    $(this).closest(".sidebar-section").removeClass("show-attachment-form")
    $("#new_form_answer_attachment .errors").empty()
    $("#new_form_answer_attachment").removeClass("uploaded-file")
    $("#form_answer_attachment_title").val(null)
    $("#form_answer_attachment_restricted_to_admin").prop("checked", false)

  formClass = '.edit_form_answer_attachment'

  $(document).on 'click', "#{formClass} a", (e) ->
    e.preventDefault()
    form = $(this).parents(formClass)
    sidebarSection = form.closest(".sidebar-section")
    $.ajax
      url: form.attr('action'),
      type: 'DELETE'
    form.parents('.form_answer_attachment').remove()
    if $('.form_answer_attachment').length == 0
      sidebarSection.find(".document-list .p-empty").removeClass("visuallyhidden")

  $(document).on "click", ".form-edit-link", (e) ->
    e.preventDefault()
    $(this).closest(".form-group").addClass("form-edit")
  $(".submit-assessment").on "ajax:error", (e, data, status, xhr) ->
    errors = data.responseJSON
    $(this).addClass("field-with-errors")
    $(this).closest(".panel-body").find("textarea").each ->
      unless $(this).val().length
        $(this).closest(".input").addClass("field-with-errors")
    $(this).find(".feedback-holder").addClass("error")
    $(this).find(".feedback-holder").html(errors.error)
  $(".submit-assessment").on "ajax:success", (e, data, status, xhr) ->
    $(this).closest(".panel-body").find(".field-with-errors").removeClass("field-with-errors")
    $(this).find(".feedback-holder").removeClass("error").addClass("alert alert-success")

    successMessage = "Assessment submitted"
    if $(this).closest(".panel-collapse").hasClass("section-case-summary")
      successMessage = "Case summary submitted"
    $(this).find(".feedback-holder").html(successMessage)
    $(this).find("input:submit").remove()

  $(document).on "click", ".form-save-link", (e) ->
    link = $(this)
    e.preventDefault()
    formGroup = link.closest(".form-group")
    form = formGroup.closest("form")
    area = formGroup.find("textarea:visible")
    formGroup.removeClass("form-edit")

    if area.val().length
      formGroup.find(".form-value p").text(area.val())
      updatedSection = link.data("updated-section")
      $(this).closest(".panel-body").find(".field-with-errors").removeClass("field-with-errors")
      $(this).closest(".panel-body").find(".feedback-holder.error").html("")
      $(this).closest(".panel-body").find(".feedback-holder").removeClass("error")
      formGroup.find("textarea").each ->
        if $(this).val().length
          $(this).closest(".input").removeClass("field-with-errors")
      if updatedSection
        input = form.find("input[name='updated_section']")
        if input.length
          input.val(updatedSection)
      form.submit()
  $("#new_review_audit_certificate input[type='radio']").on "change", ->
    area = $(".audit-cert-description")
    if $(this).val() == "confirmed_changes"
      area.removeClass("if-js-hide")
    else
      area.addClass("if-js-hide")
  $(document).on "submit", "#new_assessor_assignment_collection", (e) ->
    form = $(this)
    ids = ""
    $(".form-answer-check:checked").each ->
      ids += ($(@).val() + ",")
    $("#assessor_assignment_collection_form_answer_ids").val(ids)

  $("#check_all").on "change", ->
    select_all_value = $(this).prop("checked")
    $(this).closest("table").find(".form-answer-check").prop("checked", select_all_value)

  # Show/hide the bulk assign assessors form
  $(".bulk-assign-assessors-link").on "click", (e) ->
    e.preventDefault()
    $(".bulk-assign-assessors-form").closest(".container").addClass("show-bulk-assign")

  $(".bulk-assign-assessors-cancel-link").on "click", (e) ->
    e.preventDefault()
    $(".bulk-assign-assessors-form").closest(".container").removeClass("show-bulk-assign")

changeRagStatus = ->
  $(document).on "click", ".btn-rag .dropdown-menu a", (e) ->
    e.preventDefault()
    rag_clicked = $(this).closest("li").attr("class")
    rag_status = $(this).closest(".btn-rag").find(".dropdown-toggle")
    rag_status.removeClass("rag-neutral")
              .removeClass("rag-positive")
              .removeClass("rag-average")
              .removeClass("rag-negative")
              .removeClass("rag-blank")
              .addClass(rag_clicked)
    rag_status.find(".rag-text").text($(this).find(".rag-text").text())
    $(this).closest(".panel-body").find(".field-with-errors").removeClass("field-with-errors")
    $(this).closest(".panel-body").find(".feedback-holder.error").html("")
    $(this).closest(".panel-body").find(".feedback-holder").removeClass("error")

editFormAnswerAutoUpdate = ->
  $(".sic-code .form-save-link").on "click", (e) ->
    e.preventDefault()
    e.stopPropagation()
    that = $("#form_answer_sic_code")
    form = $(".edit_form_answer")
    $.ajax
      action: form.attr("action")
      data: form.serialize()
      method: "PATCH"
      dataType: "json"

      success: (result) ->
        formGroup = that.parents(".form-group")
        formGroup.removeClass("form-edit")
        formGroup.find(".form-value p").text(that.find("option:selected").text())
        sicCodes = result["form_answer"]["sic_codes"]
        counter = 1
        for row in $(".sector-average-growth td")
          $(row).text(sicCodes[counter.toString()])
          counter += 1
        $(".avg-growth-legend").text(result["form_answer"]["legend"])
bindRags =(klass) ->
  $(document).on "click", "#{klass} .btn-rag .dropdown-menu a", (e) ->
    e.preventDefault()
    ragClicked = $(this).closest("li").attr("class")
    ragClicked = ragClicked.replace("rag-", "")
    ragSection = $(this).parents(".form-group")
    form       = $(klass)
    ragSection.find("option").each ->
      if $(this).val() == ragClicked
        select = $(this).parents("select")
        select.val(ragClicked)
        section = select.data("updated-section")
        if section
          input = form.find("input[name='updated_section']")
          if input.length
            input.val(section)
    form.submit()

handleWinnersForm = ->
  removeAttendeeForm = ".remove-palace-attendee-form"
  addAttendeeForm    = ".palace-attendee-form"
  attendeeFormHolder = ".palace-attendee-container"

  $(document).on "ajax:success", attendeeFormHolder, (e, data, status, xhr) ->
    $(this).closest(attendeeFormHolder).replaceWith(data)

  $(document).on "click", ".remove-palace-attendee", (e) ->
    e.preventDefault()
    $(this).closest("form").submit()
    $(this).closest(".form-group").find(".empty-message").removeClass("visuallyhidden")

  $(document).on "ajax:success", removeAttendeeForm, (e, data, status, xhr) ->
    $(this).closest(attendeeFormHolder).remove()
    $(".attendees-forms").closest(".form-group").find(".empty-message").removeClass("visuallyhidden")
  $(document).on "click", ".add-another-attendee", (e) ->
    e.preventDefault()
    that = $(this)

    limit      = $(".attendees-forms").data("attendees-limit")
    visibleLen = $(".attendees-forms .list-attendees:visible").length
    if visibleLen < limit
      $.ajax
        type: "GET",
        url: that.attr("href")
        success: (data) ->
          $(".section-palace-attendees .panel-body").append(data)

          limit = $(".attendees-forms").data("attendees-limit")
          visibleLen = $(".attendees-forms .list-attendees:visible").length
          that.hide() if visibleLen >= limit
    else
      alert("You can not add more attendees")

handleCompanyDetailsForm = ->
  if $('.duplicatable-nested-form').length
    nestedForm = $('.duplicatable-nested-form').last().clone()
    $(".destroy_duplicate_nested_form:first").remove()
    $('.destroy_duplicate_nested_form').on 'click', (e) ->
      $(this).closest('.duplicatable-nested-form').slideUp().remove()

    $(document).on "click", ".add-previous-winning", (e) ->
      e.preventDefault()

      lastNestedForm = $('.duplicatable-nested-form').last()
      newNestedForm  = $(nestedForm).clone()
      formsOnPage    = $('.duplicatable-nested-form').length

      $(newNestedForm).find('label').each ->
        oldLabel = $(this).attr 'for'
        if oldLabel
          newLabel = oldLabel.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'for', newLabel

      $(newNestedForm).find('select, input').each ->
        oldId = $(this).attr 'id'
        if oldId
          newId = oldId.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'id', newId

        oldName = $(this).attr 'name'
        if oldName
          newName = oldName.replace(new RegExp(/\[[0-9]+\]/), "[#{formsOnPage}]")
          $(this).attr 'name', newName
      newNestedForm.find(".duplicatable-nested-form").removeClass("if-js-hide")
      $( newNestedForm ).insertAfter( lastNestedForm )

  $(document).on "ajax:success", ".company-details-forms form", (e, data, status, xhr) ->
    $(this).closest(".form-group").replaceWith($(data))

  $(".company-details-forms").on "click", ".remove-link", (e) ->
    e.preventDefault()
    parent = $(this).closest(".duplicatable-nested-form")
    parent.find("input[type='checkbox']").prop("checked", "checked")
    parent.hide()

  $(".previous-wins").on "click", ".form-save-link", (e) ->
    e.preventDefault()
    $(this).closest("form").submit()

  $(document).on "click", ".form-cancel-link", (e) ->
    e.preventDefault()
    $(this).closest(".form-edit").removeClass("form-edit")

handleReviewAuditCertificate = ->
  $("#new_review_audit_certificate").on "ajax:success", (e, data, status, xhr) ->
    $(this).find(".form-group").removeClass("form-edit")
    $(".save-review-audit").hide()
    area = $(".audit-cert-description textarea")
    confirmedChanges = $("#radio-audit-cert2")
    unless confirmedChanges.prop("checked")
      $(this).find(".form-value").html($("<p>No change necessary</p>"))
    else
      div = "<div><label>Changes made</label><p class='control-label'>#{area.val()}</p></div>"
      $(this).find(".form-value").html(div)
  $("#new_review_audit_certificate").on "click", ".save-review-audit", (e) ->
    e.preventDefault()
    $("#new_review_audit_certificate").submit()

  $(".edit-review-audit").on "click", (e) ->
    $(".save-review-audit").show()
$(document).ready(ready)
