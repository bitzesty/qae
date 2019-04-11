window.ApplicationCollaboratorsConnectionManager =

  init: (form_id, p_host, p_port, p_key, rails_env, timestamp) ->

    #
    # Checking if browser supports WebSockets technology
    #
    if typeof WebSocket == 'function'

      window.form_id = form_id

      window.pusher_host = p_host
      window.pusher_port = p_port

      window.pusher_key = p_key
      window.rails_env = rails_env

      if rails_env == "staging" || rails_env == "production"
        window.pusher_encrypted = true
      else
        window.pusher_encrypted = false

      window.pusher_section = $(".js-step-link.step-current").attr('data-step')

      ApplicationCollaboratorsConnectionManager.init_pusher(timestamp)
      ApplicationCollaboratorsConnectionManager.init_room()
      ApplicationCollaboratorsGeneralRoomTracking.login()

  init_pusher: (timestamp) ->
    CollaboratorsLog.log("[PUSHER INIT] form_id: " + window.form_id + ", host: " + window.pusher_host + ", port: " + window.pusher_port + ", key: " + window.pusher_key + ", enc: " + window.pusher_encrypted + ", section: " + window.pusher_section)

    # Init Pusher to use own Poxa server
    pusher_ops = {
      wsHost: window.pusher_host,
      wsPort: window.pusher_port,
      authTransport: 'jsonp',
      authEndpoint: "/users/form_answers/" + window.form_id + "/collaborator_access/auth/" + window.pusher_section + "/" + timestamp + ".js"
    }

    # Use encryption on live and staging
    # as they are using HTTPS
    #
    if window.pusher_encrypted == "true"
      pusher_ops["encrypted"] = true
      CollaboratorsLog.log("[PUSHER OPS] encryption turned on!")
    else
      CollaboratorsLog.log("[PUSHER OPS] encryption turned off!")

    window.pusher = new Pusher(window.pusher_key, pusher_ops)

    # Check connection status
    connection_status = pusher.connection.state
    CollaboratorsLog.log("PUSHER STATUS: " + connection_status)


  init_room: () ->
    # Introduce new channel
    channel_name = 'presence-chat-' + window.rails_env + "-" + window.form_id + '-sep-' + window.pusher_section

    CollaboratorsLog.log("[PUSHER INIT ROOM] ------------------------ channel_name: " + channel_name)

    window.pusher_current_channel = window.pusher.subscribe(channel_name)

    # Check if subscription was successful
    window.pusher_current_channel.bind 'pusher:subscription_succeeded', (members) ->
      CollaboratorsLog.log('[subscription_succeeded] Count ' + members.count)

      ApplicationCollaboratorsAccessManager.set_access_mode()
      members.each (member) =>
        ApplicationCollaboratorsAccessManager.register_member(member)

      return

    # Handle member removed
    window.pusher_current_channel.bind 'pusher:member_removed', (member) ->
      CollaboratorsLog.log('[member_removed] Count ' + window.pusher_current_channel.members.count)

      ApplicationCollaboratorsAccessManager.try_mark_as_editor()

      return

    # Handle member added
    window.pusher_current_channel.bind 'pusher:member_added', (member) ->
      CollaboratorsLog.log('[member_added] Count ' + window.pusher_current_channel.members.count)
      ApplicationCollaboratorsAccessManager.register_member(member)

      return
