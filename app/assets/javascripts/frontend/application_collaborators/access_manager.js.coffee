window.ApplicationCollaboratorsAccessManager =

  set_access_mode: () ->
    editor_id = ApplicationCollaboratorsAccessManager.current_editor_id()

    CollaboratorsLog.log("[SET ACCESS MODE] ------------ CURRENT EDITOR IS -------- " + editor_id)
    previous_editor_id = window.last_editor_id
    console.log("previous editor was: " + previous_editor_id)
    ApplicationCollaboratorsAccessManager.track_current_editor(editor_id)

    if ApplicationCollaboratorsAccessManager.i_am_current_editor()
      CollaboratorsLog.log("[EDITOR MODE] ----------------------")

      ApplicationCollaboratorsEditorBar.hide_collaborators_bar()

      if previous_editor_id != undefined && previous_editor_id != ApplicationCollaboratorsAccessManager.current_editor_id()
        CollaboratorsLog.log("[NOW IM EDITOR] ---- REFRESHING PAGE")

        ApplicationCollaboratorsEditorBar.show_loading_bar()

        # Redirect user to same page in order to get the new changes 
        redirect_url = $(".js-step-link.step-current a").attr('href')
        redirect_url += "&form_refresh=true"

        #
        # In case it was an attempt to submit and validation errors are present
        # then we are passing validate_on_form_load option
        # in order to show validation errors to user after redirection
        #
        if window.location.href.search("validate_on_form_load") > 0
          redirect_url += "&validate_on_form_load=true"

        window.location.href = redirect_url
    else
      CollaboratorsLog.log("[READ ONLY MODE] ----------------------")

      ApplicationCollaboratorsFormLocker.lock_current_form_section()
      ApplicationCollaboratorsEditorBar.render_collaborators_bar()

  i_am_current_editor: () ->
    ApplicationCollaboratorsAccessManager.current_editor_id() == window.user_id &&
      window.tab_ident == ApplicationCollaboratorsAccessManager.current_editor().tab_ident

  im_in_viewer_mode: () ->
    !ApplicationCollaboratorsAccessManager.i_am_current_editor()

  current_editor_id: () ->
    editor_id = window.current_channel_members.split("/").find((el) => el.includes("EDITOR")).split(":")[0]
    
    return editor_id

  current_editor: () ->
    editor = window.current_channel_members.split("/").find((el) => el.includes("EDITOR")).split(":")
    editor_info = {
      id: editor[0],
      tab_ident: editor[1],
      email: editor[2],
      name: editor[3]
    }

    editor_info

  track_current_editor: (editor_id) ->
    window.last_editor_id = editor_id
