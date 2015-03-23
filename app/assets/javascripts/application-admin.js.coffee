#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require jquery.fileupload
#= require select2.full.min
#= require ./frontend/password_strength
#= require_tree ./admin
#= require search
#= require jquery-ui

$(document).ready(() ->
  $("html").removeClass("no-js").addClass("js")
  ($ ".timepicker").timePicker()
  ($ ".datepicker").datepicker()
  ($ "select.select2").select2({width: "style"})
)
