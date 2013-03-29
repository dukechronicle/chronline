initialize '.embedded-image', ->
  console.log 'init with'
  console.log $(this)
  $(this).each( ->
    $(this).addClass('img-right')
    $(this).parent().prepend($(this).remove())
    console.log 'this'
    console.log $(this)
  )
  console.log $(this)
