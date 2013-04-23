initialize '.embedded-image', ->
  right = false
  $(this).each( ->
    $(this).addClass(if right then 'img-right' else 'img-left')
    $(this).parent().prepend($(this).remove())
    right = !right
    return
  )
