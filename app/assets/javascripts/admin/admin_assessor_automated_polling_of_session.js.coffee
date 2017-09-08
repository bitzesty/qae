window.AdminAssessorAutomatedPollingOfSession =

  init: (namespace) ->
    AdminAssessorAutomatedPollingOfSession.poll(namespace)

  poll: (namespace) ->
    setInterval (->
      $.ajax
        url: "/" + namespace + "/session_checks.json"
        type: 'GET'
        complete: (response) ->
          if response.status == 401
            window.location.href = "/" + namespace + "s/sign_in?session_expired=true"
            return
          return
        dataType: 'json'
      return
    ), 10000
