addImages = ($imageSelect, $imagePicker, images) ->
  for image in images
    $imageTag = $("<img src=\"#{image.thumbnail_url}\" />")
    $imageSelect.find('.modal-body .images').append($imageTag)
    do (image) ->
      $imageTag.click ->
        selectImage($imagePicker, image)

removeImage = ($imagePicker) ->
  $imagePicker.find('input').val(undefined)
  $imagePicker.find('.image-display').removeAttr('data-content')
  setVisibilities($imagePicker)

selectImage = ($imagePicker, image) ->
  $imagePicker.find('input').val(image.id)
  $imagePicker.find('.image-display').attr(
    'data-content', "<img src=\"#{image.thumbnail_url}\" />")
  setVisibilities($imagePicker)
  $('#image-select').modal('hide')

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

loadImages = ($imagePicker, page=1) ->
  ->
    data = {limit: 35, page: page++}
    $.get fullUrl('api', '/images'), data, (images) =>
      addImages($(this), $imagePicker, images)

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
    $imageSelect.loadImages = loadImages($imagePicker)
    $imageSelect.loadImages()
    $imageSelect.on 'click', '#next', ->
      $imageSelect.loadImages()
