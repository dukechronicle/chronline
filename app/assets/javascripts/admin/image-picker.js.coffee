removeImage = ($imagePicker) ->
  $imagePicker.find('input').val(undefined)
  $imagePicker.find('.image-display').removeAttr('data-content')
  setVisibilities($imagePicker)

selectImage = ($imagePicker, image) ->
  $imagePicker.find('input').val(image.id)
  $imagePicker.find('.image-display').data('url', image.thumbnail_url)
  setVisibilities($imagePicker)
  $('#image-select').modal('hide')

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
  $(this).each -> setVisibilities($(this))

  $(this).find('.image-display').each ->
    $(this).popover(
      html: true
      trigger: 'hover'
      content: => "<img src=\"#{$(this).data('url')}\" />"
    )

  $(this).on 'click', '.image-remove', (e) ->
    e.preventDefault()
    $imagePicker = $(this).parents('.control-group.image_picker').first()
    removeImage($imagePicker)

  $(this).on 'click', '.image-attach', (e) ->
    e.preventDefault()
    $imagePicker = $(this).parents('.control-group.image_picker').first()
    imageSelector.open(selectImage.bind(this, $imagePicker))
