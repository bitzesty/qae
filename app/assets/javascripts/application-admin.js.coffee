#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require jquery.fileupload
#= require ./frontend/password_strength
#= require_tree ./admin
#= require search
#= require jquery-ui

$(document).ready(() ->
  $("html").removeClass("no-js").addClass("js")
  ($ ".timepicker").timePicker()
  ($ ".datepicker").datepicker()
)
