initialize '.embedded-image', ->
  $(this).each( (i) ->
    $(this).parent().prepend($(this).remove())
  )
