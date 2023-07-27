ready = ->
  $(document).on 'submit', '.new_comment', (e) ->
    that = $(this)
    e.preventDefault()
    $.ajax
      url: $(this).attr('action')
      type: 'POST'
      data: $(this).serialize()
      dataType: 'HTML'
      success: (data) ->
        LS.removeItem(that.parents(".comments-container").find("textarea").data("autosave-key"))
        that.parents(".comments-container").find("textarea").val("")
        that.parents(".comments-container").find(".comment-insert").after(data)
        that.find("input[type='checkbox']").prop("checked", false)
        that.find(".comment-actions").removeClass("comment-flagged")
        numberWrapper = that.closest(".panel").find(".panel-heading .comments-number")
        if numberWrapper.find(".number").length
          currentNumber = parseInt(numberWrapper.find(".number").html())

          numberWrapper.find(".number").html("#{currentNumber + 1}")
        else
          numberWrapper.html("(<span class='number'>1</span>)")

        commentWrapper = that.parents(".comments-container").find(".show-comment").first()

        signatureWrapper = that.closest(".panel").find(".panel-heading .signature")

        if commentWrapper.data("signature")
          signatureWrapper.html(commentWrapper.data("signature"))
        else
          signatureWrapper.html("")

        window.fire(that[0], 'ajax:x:success', data)

  $(document).on 'submit', '.destroy-comment', (e) ->
    e.preventDefault()
    $.ajax
      url: $(this).attr('action')
      type: 'DELETE'
      success: () =>
        numberWrapper = $(@).closest(".panel").find(".panel-heading .comments-number")
        if numberWrapper.find(".number").length
          currentNumber = parseInt(numberWrapper.find(".number").html())
          currentNumber = currentNumber - 1

          if currentNumber > 0
            numberWrapper.find(".number").html("#{currentNumber}")
          else
            numberWrapper.html("")

        commentWrapper = $($(@).closest(".panel").find(".comments-container .show-comment")[1])
        signatureWrapper = $(@).closest(".panel").find(".panel-heading .signature")

        if commentWrapper.length && commentWrapper.data("signature")
          signatureWrapper.html(commentWrapper.data("signature"))
        else
          signatureWrapper.html("")

        $(@).parents('.comment').remove()


  toggleFlagged()
  deleteCommentAlert()

toggleFlagged = ->
  $(document).on "click", ".js-link-flag-comment", (e) ->
    e.preventDefault()
    flagged = "comment-flagged"
    newComment = $(this).closest(".comment-actions")
    newComment.toggleClass(flagged)
    toggleNewCommentFlag =(commentBox, flagged) ->
      checkbox = commentBox.find("input[type='checkbox']")
      checkbox.prop("checked", commentBox.hasClass(flagged))

    toggleNewCommentFlag(newComment, flagged)

    editComment = $(this).closest(".comment")
    editComment.toggleClass(flagged)
    state = editComment.is(flagged)
    editComment.find(".flag-comment-checkbox").
      prop("checked", editComment.hasClass(flagged))
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
