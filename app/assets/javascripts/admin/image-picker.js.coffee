setVisibilities = ($imagePicker) ->
  if $imagePicker.find('input').val()
    $imagePicker.find('.controls > .image-attach').hide()
    $imagePicker.find('.image-change').show()
    $imagePicker.find('.image-display').show()
  else
    $imagePicker.find('.controls > .image-attach').show()
    $imagePicker.find('.image-change').hide()
    $imagePicker.find('.image-display').hide()

initialize '.control-group.image_picker', ->
  $(this).each -> setVisibilities $(this)

  $(this).find('.image-display').each ->
    url = $(this).data('url')
    $(this).attr('data-content', "<img src=\"#{url}\" />") if url?
    $(this).popover(
      html: true
      trigger: 'hover'
    )
