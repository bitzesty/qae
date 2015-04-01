ready = ->
  changeRagStatus()
  editFormAnswerAutoUpdate()
  bindRags("#section-appraisal-form-primary .edit_assessor_assignment")
  bindRags("#section-appraisal-form-secondary .edit_assessor_assignment")
  bindRags("#section-appraisal-form-moderated .edit_assessor_assignment")
  bindRags("#section-case-summary .edit_assessor_assignment")

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
  $("#new_form_answer_attachment").fileupload
    autoUpload: false,
    add: (e, data) ->
      $("#new_form_answer_attachment").closest(".sidebar-section").addClass("show-attachment-form")
      $("#new_form_answer_attachment .btn-submit").unbind("click").on "click", (e) ->
        e.preventDefault()
        data.submit()
    success: (result, textStatus, jqXHR) ->
      $(".document-list ul").append(result)
      form = $("#new_form_answer_attachment")
      form.closest(".sidebar-section").removeClass("show-attachment-form")
      $("#form_answer_attachment_title").val(null)
      $("#form_answer_attachment_restricted_to_admin").prop("checked", false)

  # Move the attach document button
  $(".attachment-link").removeClass("if-js-hide")
  $(".attachment-link").addClass("btn btn-default btn-block btn-attachment")
  $(".attachment-link").prepend("Attach Document")
  $(".attachment-link").prepend("<span class='glyphicon glyphicon-paperclip'></span>")
  $(".attachment-link").prependTo("#new_form_answer_attachment")

  $(".js-attachment-form .btn-cancel").on "click", (e) ->
    e.preventDefault()
    $(this).closest(".sidebar-section").removeClass("show-attachment-form")
    $("#new_form_answer_attachment").removeClass("uploaded-file")
    $("#form_answer_attachment_title").val(null)
    $("#form_answer_attachment_restricted_to_admin").prop("checked", false)

  formClass = '.edit_form_answer_attachment'

  $(document).on 'click', "#{formClass} a", (e) ->
    form = $(this).parents(formClass)
    $.ajax
      url: form.attr('action'),
      type: 'DELETE'
    form.parents('.form_answer_attachment').remove()
    if $('.form_answer_attachment').length == 0
      noDoc = $("<p class='p-empty'></p>")
      noDoc.text('No documents have been attached to this case.')
      $('.document-list').prepend(noDoc)

  $(document).on "click", ".form-edit-link", (e) ->
    e.preventDefault()
    $(this).closest(".form-group").addClass("form-edit")
  $(".submit-assessment").on "ajax:error", (e, data, status, xhr) ->
    errors = data.responseJSON
    $(this).find(".feedbackHolder").html(errors.error)
  $(".submit-assessment").on "ajax:success", (e, data, status, xhr) ->
    $(this).find(".feedbackHolder").html("Assessment Submitted")
    $(this).find("input:submit").remove()

  $(document).on "click", ".form-save-link", (e) ->
    link = $(this)
    e.preventDefault()
    formGroup = link.closest(".form-group")
    form = formGroup.closest("form")
    area = formGroup.find("textarea:visible")
    formGroup.removeClass("form-edit")

    if area.length
      formGroup.find(".form-value p").text(area.val())
      updatedSection = link.data("updated-section")
      if updatedSection
        input = form.find("input[name='updated_section']")
        if input.length
          input.val(updatedSection)
      form.submit()
  $("#new_review_audit_certificate input[type='radio']").on "change", ->
    area = $(".audit-cert-description")
    if $(this).val() == "confirmed_changes"
      area.show()
    else
      area.hide()
  $(document).on "submit", "#new_assessor_assignment_collection", (e) ->
    form = $(this)
    ids = ""
    $(".form-answer-check:checked").each ->
      ids += ($(@).val() + ",")
    $("#assessor_assignment_collection_form_answer_ids").val(ids)

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

editFormAnswerAutoUpdate = ->
  $(".sic-code .form-save-link").on "click", (e) ->
    e.preventDefault()
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
    ragSection.find("option").each ->
      if $(this).val() == ragClicked
        $(this).parents("select").val(ragClicked)
    $(klass).submit()

$(document).ready(ready)
