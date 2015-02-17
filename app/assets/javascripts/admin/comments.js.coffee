ready = ->
  console.log 'here'
  $('body').on 'click', '#build_new_comment', (e)->
    e.preventDefault()
    unless $('#new_comment').length
      $.get $(this).attr('href'), (data)->
        $('.comments-container').append(data)
      , 'html'

  $('body').on 'submit', '#new_comment', (e)->
    e.preventDefault()
    $.ajax
      url: $(this).attr('action'),
      type: 'POST',
      data: $(this).serialize(),
      dataType: 'HTML',
      success: (data)->
        $('#new_comment').remove()
        $('.comments-container').append(data)

  $('body').on 'submit', '.edit_comment', (e)->
    e.preventDefault()
    $.ajax
      url: $(this).attr('action'),
      type: 'DELETE'
    $(this).parents('.comment').remove()

$(document).ready(ready)
