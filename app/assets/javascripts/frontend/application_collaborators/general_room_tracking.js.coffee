window.ApplicationCollaboratorsGeneralRoomTracking =

  login: () ->
    # Introduce general channel
    channel_name = 'presence-chat-' + window.rails_env + "-" + window.form_id + '-general'

    CollaboratorsLog.log("[INIT GENERAL ROOM] ------------------------ channel_name: " + channel_name)

    window.App.generalRoom = App.cable.subscriptions.create { channel: "GeneralRoomChannel", channel_name: channel_name, user_id: window.user_id },
      connected: ->
        console.log("connected to GENERAL ROOM")

      received: (data) ->
        console.log("receieved data", data.collaborators)

        window.general_room_members = data.collaborators
        ApplicationCollaboratorsAccessManager.set_access_mode()

      disconnected: ->
        console.log("disconnected")

  there_are_other_collaborators_here: () ->
    window.general_room_members &&
    window.general_room_members.split('/').length > 1
