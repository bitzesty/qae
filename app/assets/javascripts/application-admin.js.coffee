#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require vendor/accessible-autocomplete.min
#= require vendor/file_upload/jquery.ui.widget
#= require vendor/file_upload/jquery.iframe-transport
#= require vendor/file_upload/jquery.fileupload
#= require vendor/file_upload/jquery.fileupload-process
#= require vendor/file_upload/jquery.fileupload-validate
#= require select2.full.min
#= require Countable

# crypt.io: secures browser storage with the SJCL crypto library
#= require vendor/sjcl
#= require vendor/crypt.io.min

#= require ./frontend/local_storage
#= require ./frontend/palace_invite
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
  $("#assessor_assignment_collection_primary_assessor_id").next("span").find("span.select2-selection--single").attr("title", "Select a primary assessor")
  $("#assessor_assignment_collection_secondary_assessor_id").next("span").find("span.select2-selection--single").attr("title", "Select a secondary assessor")
)
