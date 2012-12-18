initialize '.add-field', ->
  $(this).click (e) ->
    e.preventDefault()
    $item = $(this).siblings('.addible-field').last()
    $newItem = $item.clone()
    i = parseInt($item.children('input').attr('id').match(/_(\d+)/)[1])
    $newItem.children('input').attr 'id', (__, id) ->
      id.replace(/_(\d+)/, "_#{i + 1}")
    $newItem.children('input').val(undefined)
    $item.after $newItem
