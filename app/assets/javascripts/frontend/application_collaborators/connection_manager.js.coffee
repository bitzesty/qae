window.ApplicationCollaboratorsConnectionManager =

  init: (form_id, user_id, p_host, p_port, p_key, rails_env, timestamp) ->

    #
    # Checking if browser supports WebSockets technology
    #
    if typeof WebSocket == 'function'

      window.form_id = form_id

      window.pusher_host = p_host
      window.pusher_port = p_port

      window.pusher_key = p_key
      window.rails_env = rails_env
      window.user_id = user_id

      if rails_env == "staging" || rails_env == "production"
        window.pusher_encrypted = true
      else
        window.pusher_encrypted = false

      window.pusher_section = $(".js-step-link.step-current").attr('data-step')

      # ApplicationCollaboratorsConnectionManager.init_pusher(timestamp)
      ApplicationCollaboratorsConnectionManager.init_room()
      # ApplicationCollaboratorsGeneralRoomTracking.login()

  init_room: () ->
    # Introduce new channel
    channel_name = 'presence-chat-' + window.rails_env + "-" + window.form_id + '-sep-' + window.pusher_section

    CollaboratorsLog.log("[PUSHER INIT ROOM] ------------------------ channel_name: " + channel_name)

    # window.pusher_current_channel = window.pusher.subscribe(channel_name)

    window.App.collaborators = App.cable.subscriptions.create { channel: "CollaboratorsChannel", channel_name: channel_name, user_id: window.user_id },
        connected: ->
          console.log("successfully connected")
  
        received: (data) ->
          console.log("receieved data", data.collaborators)
          # console.log("Member count: " + data.collaborators.split("/").length)

          window.current_channel_members = data.collaborators
          ApplicationCollaboratorsAccessManager.set_access_mode()

        disconnected: ->
          console.log("disconnected")

    # App.collaborators.unsubscribed()
        
    # Check if subscription was successful
    # window.pusher_current_channel.bind 'pusher:subscription_succeeded', (members) ->
    #   CollaboratorsLog.log('[subscription_succeeded] Count ' + members.count)

    #   ApplicationCollaboratorsAccessManager.set_access_mode()
    #   members.each (member) =>
    #     ApplicationCollaboratorsAccessManager.register_member(member)

    #   return

    # # Handle member removed
    # window.pusher_current_channel.bind 'pusher:member_removed', (member) ->
    #   CollaboratorsLog.log('[member_removed] Count ' + window.pusher_current_channel.members.count)

    #   ApplicationCollaboratorsAccessManager.try_mark_as_editor()

    #   return

    # # Handle member added
    # window.pusher_current_channel.bind 'pusher:member_added', (member) ->
    #   CollaboratorsLog.log('[member_added] Count ' + window.pusher_current_channel.members.count)
    #   ApplicationCollaboratorsAccessManager.register_member(member)

    #   return
