initialize '.embedded-image', ->
  $(this).each( ->
    $(this).parent().prepend($(this).remove())
  )
