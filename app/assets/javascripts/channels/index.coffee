#= require actioncable
#= require_self
#= require_tree .

@App = {}
App.cable = ActionCable.createConsumer()
