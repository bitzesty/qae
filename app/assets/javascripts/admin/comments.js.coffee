ready = ->
  $('body').on 'submit', '.new_comment', (e)->
    that = $(this)
    e.preventDefault()
    $.ajax
      url: $(this).attr('action'),
      type: 'POST',
      data: $(this).serialize(),
      dataType: 'HTML',
      success: (data)->
        that.parents(".comments-container").find("textarea").val("")
        that.parents(".comments-container").find(".comment-insert").after(data)

  $('body').on 'submit', '.destroy-comment', (e)->
    e.preventDefault()
    $.ajax
      url: $(this).attr('action'),
      type: 'DELETE'
    $(this).parents('.comment').remove()

  toggleFlagged()
  deleteCommentAlert()

toggleFlagged = ->
  $(document).on "click", ".link-flag-comment", (e) ->
    e.preventDefault()

    newComment = $(this).closest(".comment-actions")
    newComment.toggleClass("comment-flagged")
    state = newComment.is(".comment-flagged")
    newComment.closest(".comment-new").find(".flag-comment-checkbox").prop("checked", state)

    editComment = $(this).closest(".comment")
    editComment.toggleClass("comment-flagged")
    state = editComment.is(".comment-flagged")
    editComment.find(".flag-comment-checkbox").prop("checked", state)
    form = editComment.find(".edit_comment")
    form.submit()
deleteCommentAlert = ->
  $(document).on "click", ".link-delete-comment", (e) ->
    e.preventDefault()

    $(".comment.show-delete-comment").removeClass("show-delete-comment")
    $(this).closest(".comment").addClass("show-delete-comment")

  $(document).on "click", ".link-delete-comment-close", (e) ->
    e.preventDefault()

    $(".comment.show-delete-comment").removeClass("show-delete-comment")

$(document).ready(ready)
