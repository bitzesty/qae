ready = ->
  changeRagStatus()
  editFormAnswerAutoUpdate()
  bindRags("#section-appraisal-form-primary .edit_assessor_assignment")
  bindRags("#section-appraisal-form-secondary .edit_assessor_assignment")
  bindRags("#section-appraisal-form-moderated .edit_assessor_assignment")

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
    success: (result, textStatus, jqXHR)->
      $("#new_form_answer_attachment").addClass("uploaded-file")
      $("#new_form_answer_attachment ul").append(result)

  # Show/hide the attach document form
  $(".js-attachment-link").on "click", (e) ->
    e.preventDefault()
    $(this).closest(".sidebar-section").addClass("show-attachment-form")

  $(".js-attachment-form .btn-cancel").on "click", (e) ->
    e.preventDefault()
    $(this).closest(".sidebar-section").removeClass("show-attachment-form")

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
    e.preventDefault()
    formGroup = $(this).closest(".form-group")
    area = formGroup.find("textarea:visible")
    formGroup.removeClass("form-edit")

    if area.length
      formGroup.find(".form-value p").text(area.val())
      $(formGroup).closest("form").submit()

  # Show the audit certificates `changes made` textarea
  # TODO temp
  $("[name='radio-audit-cert']").on "change", ->
    $(".audit-cert-changed-val p").text($(".audit-cert-description textarea").val())

    if $("#radio-audit-cert2:checked").size() > 0
      $(this).closest(".panel-body").addClass("audit-cert-changes-made")
      $(this).closest(".panel-body").removeClass("audit-cert-no-change")
    else
      $(this).closest(".panel-body").removeClass("audit-cert-changes-made")
      $(this).closest(".panel-body").addClass("audit-cert-no-change")

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
  $("#form_answer_sic_code").on "change", ->
    that = $(this)
    form = that.parents("form")
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
