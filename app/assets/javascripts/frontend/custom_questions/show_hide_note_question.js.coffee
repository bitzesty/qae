window.ShowHideNoteQuestion = init: ->
  $(document).on 'click', '.js-hidden-note-title', ->
    $(this).closest(".question-group").
           find(".js-hidden-note-description").
           toggleClass("hidden")
