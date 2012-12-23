removeImage = ($imagePicker) ->
  $imagePicker.find('input').val(undefined)
  $imagePicker.find('.image-display').removeAttr('data-content')
  setVisibilities($imagePicker)

createModal = (version) ->
  template = $('#image-select-template').text()
  html = _.template(template, {})
  $imageSelect = $(html)
  $imageSelect.modal('show').on('hidden', -> $(this).remove())

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

  $(this).on 'click', '.image-remove', (e) ->
    e.preventDefault()
    $imagePicker = $(this).parents('.control-group.image_picker').first()
    removeImage($imagePicker)

  $(this).on 'click', '.image-attach', (e) ->
    e.preventDefault()
    $imagePicker = $(this).parents('.control-group.image_picker').first()
    $imageSelect = createModal()

    $.get fullUrl('api', '/images'), (images) ->
      addImages($imageSelect, $imagePicker, images)
