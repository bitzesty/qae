#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require jquery.iframe-transport
#= require jquery.fileupload
#= require select2.full.min
#= require Countable

# crypt.io: secures browser storage with the SJCL crypto library
#= require vendor/sjcl
#= require vendor/crypt.io.min

#= require ./frontend/admin_assessor_local_storage
#= require ./frontend/password-strength-indicator
#= require ./frontend/textarea-autoResize
#= require ./frontend/text-character-count
#= require_tree ./admin
#= require search
#= require jquery-ui
#= require vendor/zxcvbn
#= require vendor/jquery-debounce
#= require clean-paste


$(document).ready(() ->
  $("html").removeClass("no-js").addClass("js")
  ($ ".timepicker").timePicker()
  ($ ".datepicker").datepicker({dateFormat: "dd/mm/yy"})
  ($ "select.select2").select2({width: "style"})
)
