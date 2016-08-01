window.CollaboratorsLog =

  log: (message) ->
    if typeof console != "undefined" && window.rails_env != "production"
      console.log(message)
