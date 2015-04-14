#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require jquery.fileupload
#= require select2.full.min
#= require ./frontend/password-strength-indicator
#= require_tree ./admin
#= require search
#= require jquery-ui
#= require vendor/zxcvbn
#= require vendor/jquery-debounce

$(document).ready(() ->
  $("html").removeClass("no-js").addClass("js")
  ($ ".timepicker").timePicker()
  ($ ".datepicker").datepicker({dateFormat: "dd/mm/yy"})
  ($ "select.select2").select2({width: "style"})
)
