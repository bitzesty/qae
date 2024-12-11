window.ApplicationCollaboratorsConnectionManager =

  init: (form_id, user_id, rails_env) ->

    #
    # Checking if browser supports WebSockets technology
    #
    if typeof WebSocket == 'function'

      window.form_id = form_id

      window.rails_env = rails_env
      window.user_id = user_id

      window.tab_ident = ApplicationCollaboratorsConnectionManager.get_tab_ident()

      window.form_section = $(".js-step-link.step-current").attr('data-step')

      ApplicationCollaboratorsConnectionManager.init_room()
      ApplicationCollaboratorsGeneralRoomTracking.login()

  init_room: () ->
    # Introduce new channel
    channel_name = 'presence-chat-' + window.rails_env + "-" + window.form_id + '-sep-' + window.form_section

    CollaboratorsLog.log("[INIT ROOM] ------------------------ channel_name: " + channel_name)

    window.App.collaborators = App.cable.subscriptions.create { channel: "CollaboratorsChannel", channel_name: channel_name, user_id: window.user_id, current_tab: window.tab_ident },
        received: (data) ->
          window.current_channel_members = data.collaborators
          ApplicationCollaboratorsAccessManager.set_access_mode()

  get_tab_ident: () ->
    document.cookie.split('; ').find((c) => c.split("=")[0] == 'public_tab_ident').split('=')[1]

