window.ApplicationCollaboratorsEditorBar =

  render_collaborators_bar: () ->
    editor = ApplicationCollaboratorsAccessManager.current_editor()

    if editor
      current_editor_name = editor.name + " (" + editor.email + ")"

      subscription = App.cable.subscriptions.subscriptions[0]
      me = subscription && subscription.identifier

      if me == editor.id
        message = "It seems you already opened this section on another tab or browser!"
      else
        message = "Currently, " + current_editor_name + " is working on this section! Try later!"
    else
      message = "No active editor at the moment."

    $(".js-collaborators-bar").removeClass('hidden').text(message)

  hide_collaborators_bar: () ->
    $(".js-collaborators-bar").addClass('hidden')
                              .text("")

  show_loading_bar: () ->
    $(".js-collaborators-bar").removeClass('hidden')
                              .text("Loading ...")
