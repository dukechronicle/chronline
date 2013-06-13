initialize '.embedded-image', ->
  $(this).each (i) ->
    $(this).addClass(if i % 2 == 0 then 'img-right' else 'img-left')
    # Move to beginning of paragraph
    $(this).parent().prepend($(this).remove())
