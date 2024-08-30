window.ApplicationCollaboratorsAccessManager =

  current_editor: null

  set_access_mode: (editor) ->
    @current_editor = editor
    if editor == App.presence.identifier
      CollaboratorsLog.log("[EDITOR MODE] ----------------------")
    else
      CollaboratorsLog.log("[READ ONLY MODE] ----------------------")
      ApplicationCollaboratorsFormLocker.lock_current_form_section()
      ApplicationCollaboratorsEditorBar.render_collaborators_bar()

  register_member: (user) ->
    if user.id == App.presence.identifier
      CollaboratorsLog.log("[ME IS MEMBER] ------------------------- " + user.name)
    else
      CollaboratorsLog.log("[ANOTHER MEMBER] ------------------------- " + user.name)

  unregister_member: (user) ->
    if user.id == @current_editor
      CollaboratorsLog.log("[EDITOR LEFT] ----------------------")
      @current_editor = null
      ApplicationCollaboratorsFormLocker.unlock_current_form_section()
      ApplicationCollaboratorsEditorBar.hide_collaborators_bar()
