ready = ->
  $('body').on 'click', '#build_new_comment', (e)->
    e.preventDefault()
    unless $('#new_comment').length
      $.get $(this).attr('href'), (data)->
        $('.comments-container').append(data)
      , 'html'

  $('body').on 'submit', '#new_comment', (e)->
    e.preventDefault()
    $.ajax
      url: $(this).attr('action'),
      type: 'POST',
      data: $(this).serialize(),
      dataType: 'HTML',
      success: (data)->
        $('#new_comment').remove()
        $('.comments-container .comment-footer').before(data)

  $('body').on 'submit', '.edit_comment', (e)->
    e.preventDefault()
    $.ajax
      url: $(this).attr('action'),
      type: 'DELETE'
    $(this).parents('.comment').remove()

  toggleFlagged()
  showCommentsSidebar()
  deleteCommentAlert()

showCommentsSidebar = ->
  $(document).on "click", ".link-comment", (e) ->
    e.preventDefault()
    $(this).closest(".col-sidebar").parent().toggleClass("sidebar-open")

toggleFlagged = ->
  $(document).on "click", ".link-flag", (e) ->
    e.preventDefault()

    if $(this).find(".icon-flagged").size() > 0
      $(this).find(".icon-flagged").addClass("icon-unflagged").removeClass("icon-flagged")
    else
      $(this).find(".icon-unflagged").addClass("icon-flagged").removeClass("icon-unflagged")

deleteCommentAlert = ->
  $(document).on "click", ".link-delete-comment", (e) ->
    e.preventDefault()

    $(".comment.show-delete-comment").removeClass("show-delete-comment")
    $(this).closest(".comment").addClass("show-delete-comment")

  $(document).on "click", ".link-delete-comment-close", (e) ->
    e.preventDefault()

    $(".comment.show-delete-comment").removeClass("show-delete-comment")

$(document).ready(ready)
