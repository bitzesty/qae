window.ApplicationCollaboratorsAccessManager =

  set_access_mode: () ->
    editor_id = ApplicationCollaboratorsAccessManager.current_editor_id()
    # CollaboratorsLog.log("[SET ACCESS MODE] ------------ CURRENT EDITOR IS -------- " + editor_id)
    previous_editor_id = window.pusher_last_editor_id
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

  switch_rooms: (current_step) ->
    # Unsubscribe client from current section room
    App.collaborators.unsubscribe()
    App.cable.subscriptions.remove(App.collaborators)
    # Clean up last editor id as we switched to another section
    window.pusher_last_editor_id = null;

    # And hide collaborators info bar
    ApplicationCollaboratorsEditorBar.hide_collaborators_bar()

    # CollaboratorsLog.log("[TAB SWITCH] ------------- Log out from (" + room + ") to " + current_step + " --------------------")

    # Set new pusher section
    window.form_section = current_step;

    # Set new login timestamp for user
    timestamp = new Date().getTime();

    # Init new room based on selected section
    ApplicationCollaboratorsConnectionManager.init_room()

  i_am_current_editor: () ->
    ApplicationCollaboratorsAccessManager.current_editor_id() == window.user_id &&
      window.tab_ident == ApplicationCollaboratorsAccessManager.current_editor().tab_ident

  im_in_viewer_mode: () ->
    !ApplicationCollaboratorsAccessManager.i_am_current_editor()

  get_member_info: (m) ->
    return ("ID: " + m.id + ", NAME: " + m.info.name + ", JOINED AT: " + m.info.joined_at)

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


  try_mark_as_editor: () ->
    editor = ApplicationCollaboratorsAccessManager.current_editor()

    if ApplicationCollaboratorsAccessManager.can_be_marked_as_editor(editor)
      CollaboratorsLog.log("[NOW IM EDITOR] ----------------------")

      ApplicationCollaboratorsEditorBar.show_loading_bar()

      # Redirect user to same page in order to login him
      redirect_url = $(".js-step-link.step-current a").attr('href')
      redirect_url += "&form_refresh=true"

      #
      # In case if was attempt to submit and validation errors are present
      # then we are passing validate_on_form_load option
      # in order to show validation errors to user after redirection
      #
      if window.location.href.search("validate_on_form_load") > 0
        redirect_url += "&validate_on_form_load=true"

      window.location.href = redirect_url
    else
      #
      # If I'm not next in queue to be marked as editor
      #    or I'm already editor
      #
      # Then do not need to refresh page
      #

      if window.pusher_last_editor_id == editor.id
        CollaboratorsLog.log("[ACCESS CALC] ---------------------- I'M ALREADY EDITOR OF CURRENT TAB!")
      else
        CollaboratorsLog.log("[ACCESS CALC] ---------------------- NOPE - I STILL HAVE TO WAIT!")

  track_current_editor: (editor_id) ->
    window.pusher_last_editor_id = editor_id

  can_be_marked_as_editor: (editor) ->
    #
    # If I'm next in queue to join room as editor
    #    and I'm not previous editor
    #
    console.log("push last editor id ", window.pusher_last_editor_id)
    console.log("editor.id ", editor.id)
    ApplicationCollaboratorsAccessManager.i_am_current_editor() &&
      window.pusher_last_editor_id != editor.id
