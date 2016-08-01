window.ApplicationCollaboratorsGeneralRoomTracking =

  login: () ->
    # Introduce general channel
    channel_name = 'presence-chat-' + window.rails_env + "-" + window.form_id + '-general'

    CollaboratorsLog.log("[PUSHER INIT GENERAL ROOM] ------------------------ channel_name: " + channel_name)

    general_channel = window.pusher.subscribe(channel_name)

    # Check if subscription was successful
    # and track number of max members in room
    #
    general_channel.bind 'pusher:subscription_succeeded', (members) ->
      CollaboratorsLog.log('[GENERAL_ROOM subscription_succeeded] Count: ' + members.count)
      window.pusher_max_members_count = members.count

      return

    # Handle member added
    general_channel.bind 'pusher:member_added', (member) ->
      members_count = general_channel.members.count
      CollaboratorsLog.log('[GENERAL_ROOM member_added] Count: ' + members_count)

      if window.pusher_max_members_count < members_count
        window.pusher_max_members_count = members_count

      return

  there_are_other_collaborators_here: () ->
    window.pusher_max_members_count &&
    window.pusher_max_members_count > 1
