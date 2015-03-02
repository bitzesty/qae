ready = ->
  changeRagStatus()

  $('#new_form_answer_attachment').fileupload
    success: (result, textStatus, jqXHR)->
      $('.document-list .p-empty').remove()
      $('.document-list ul').append(result)

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


  $(document).on "click", ".js-switch-admin-view", (e) ->
    e.preventDefault()
    $(".applicant-view").toggleClass("hidden")
    $(".submitted-view").toggleClass("hidden")

  $(document).on "click", ".form-edit-link", (e) ->
    e.preventDefault()
    $(this).closest(".form-group").addClass("form-edit")

changeRagStatus = ->
  $(document).on "click", ".btn-rag .dropdown-menu a", (e) ->
    e.preventDefault()
    rag_clicked = $(this).closest("li").attr("class")
    rag_status = $(this).closest(".btn-rag").find(".dropdown-toggle")
    rag_status.removeClass("rag-neutral")
              .removeClass("rag-positive")
              .removeClass("rag-average")
              .removeClass("rag-negative")
              .addClass(rag_clicked)
    rag_status.find(".rag-text").text($(this).find(".rag-text").text())

$(document).ready(ready)
