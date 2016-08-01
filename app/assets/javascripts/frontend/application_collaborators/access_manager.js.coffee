window.ApplicationCollaboratorsAccessManager =

  register_member: (member) ->
    member_info = ApplicationCollaboratorsAccessManager.get_member_info(member)

    if member.id is String(window.pusher_current_channel.members.me.id)
      CollaboratorsLog.log("[ME IS MEMBER] ------------------------- " + member_info)
    else
      CollaboratorsLog.log("[ANOTHER MEMBER] ------------------------- " + member_info)

  set_access_mode: () ->
    editor = ApplicationCollaboratorsAccessManager.current_editor()
    CollaboratorsLog.log("[SET ACCESS MODE] ------------ CURRENT EDITOR IS -------- " + editor.id)

    ApplicationCollaboratorsAccessManager.track_current_editor(editor)

    if ApplicationCollaboratorsAccessManager.does_im_current_editor()
      CollaboratorsLog.log("[EDITOR MODE] ----------------------")

    else
      CollaboratorsLog.log("[READ ONLY MODE] ----------------------")

      ApplicationCollaboratorsFormLocker.lock_current_form_section()
      ApplicationCollaboratorsEditorBar.render_collaborators_bar()

  login_to_the_room: (current_step) ->
    # Unsubscribe client from current section room
    room = window.pusher_current_channel.name;
    window.pusher.unsubscribe(window.pusher_current_channel.name);

    # Clean up last editor id as we switched to another section
    window.pusher_last_editor_id = null;

    # And hide collaborators info bar
    ApplicationCollaboratorsEditorBar.hide_collaborators_bar()

    CollaboratorsLog.log("[TAB SWITCH] ------------- Log out from (" + room + ") to " + current_step + " --------------------")

    # Set new pusher section
    window.pusher_section = current_step;

    # Set new login timestamp for user
    timestamp = new Date().getTime();

    # Init new room based on selected section
    ApplicationCollaboratorsConnectionManager.init_pusher(timestamp)
    ApplicationCollaboratorsConnectionManager.init_room()

  my_position_in_members_queue: () ->
    i = 0
    my_index = 0

    members = window.pusher_current_channel.members
    me = members.me

    members.each (member) ->
      if member.id is String(me.id)
        my_index = i

      i += 1

    my_index

  does_im_current_editor: () ->
    ApplicationCollaboratorsAccessManager.my_position_in_members_queue() == 0

  im_in_viewer_mode: () ->
    !ApplicationCollaboratorsAccessManager.does_im_current_editor()

  normalized_members_array: () ->
    list = []

    members = window.pusher_current_channel.members
    members.each (member) ->
      list.push(member)

    return list

  get_member_info: (m) ->
    return ("ID: " + m.id + ", NAME: " + m.info.name + ", JOINED AT: " + m.info.joined_at)

  current_editor: () ->
    editor = ApplicationCollaboratorsAccessManager.normalized_members_array()[0]
    member_info = ApplicationCollaboratorsAccessManager.get_member_info(editor)

    CollaboratorsLog.log("[CURRENT EDITOR] ------------- " + member_info + " --------------------")

    return editor

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

  track_current_editor: (editor) ->
    window.pusher_last_editor_id = editor.id

  can_be_marked_as_editor: (editor) ->
    #
    # If I'm next in queue to join room as editor
    #    and I'm not previous editor
    #
    ApplicationCollaboratorsAccessManager.does_im_current_editor() &&
    window.pusher_last_editor_id != editor.id
