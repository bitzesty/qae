#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require jquery.fileupload
#= require_tree ./admin
#= require search

$(document).ready(() ->
  $("html").removeClass("no-js").addClass("js")
)
