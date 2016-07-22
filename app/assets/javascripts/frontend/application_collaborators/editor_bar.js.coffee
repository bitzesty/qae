window.ApplicationCollaboratorsEditorBar =

  render_collaborators_bar: () ->
    editor = ApplicationCollaboratorsAccessManager.current_editor()
    current_editor_name = editor.info.name + " (" + editor.info.email + ")"

    members = window.pusher_current_channel.members
    me = members.me

    if me.info.email == editor.info.email
      message = "It seems you already opened this section on another tab or browser!"
    else
      message = "Currently, " + current_editor_name + " is working on this section! Try later!"

    $(".js-collaborators-bar").removeClass('hidden')
                              .text(message)

  hide_collaborators_bar: () ->
    $(".js-collaborators-bar").addClass('hidden')
                              .text("")

  show_loading_bar: () ->
    $(".js-collaborators-bar").removeClass('hidden')
                              .text("Loading ...")
