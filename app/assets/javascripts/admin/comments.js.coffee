ready = ->
  $('body').on 'submit', '#new_comment', (e)->
    e.preventDefault()
    $.ajax
      url: $(this).attr('action'),
      type: 'POST',
      data: $(this).serialize(),
      dataType: 'HTML',
      success: (data)->
        $('#new_comment textarea').val("")
        $('.comments-container .comment-footer').before(data)

  $('body').on 'submit', '.edit_comment', (e)->
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
    $(this).closest(".comment").toggleClass("comment-flagged")

deleteCommentAlert = ->
  $(document).on "click", ".link-delete-comment", (e) ->
    e.preventDefault()

    $(".comment.show-delete-comment").removeClass("show-delete-comment")
    $(this).closest(".comment").addClass("show-delete-comment")

  $(document).on "click", ".link-delete-comment-close", (e) ->
    e.preventDefault()

    $(".comment.show-delete-comment").removeClass("show-delete-comment")

$(document).ready(ready)
