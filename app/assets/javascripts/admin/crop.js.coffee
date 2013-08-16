setCoordinates = (c) ->
  $('#image_crop_x').val(c.x)
  $('#image_crop_y').val(c.y)
  $('#image_crop_w').val(c.w)
  $('#image_crop_h').val(c.h)

updateCropSize = ->
  dim = $('#image_crop_style option:selected').data('dimensions')
  target = $('#crop-target')[0]
  options =
    onChange: setCoordinates
    onSelect: setCoordinates
    onRelease: setCoordinates
    aspectRatio: dim.width / dim.height
    minSize: [dim.width, dim.height]
    setSelect: [0, 0, dim.width, dim.height]
    trueSize: [target.naturalWidth, target.naturalHeight]
  $('#crop-target').Jcrop(options)

disableOptions = ->
  options = $('#image_crop_style option').filter(->
    info = $(this).data('dimensions')
    $('#crop-target').width() < info.width or
      $('#crop-target').height() < info.height
  ).prop('disabled', true)
  $('#image_crop_style option')
    .filter(-> not $(this).attr('disabled'))
    .first()
    .prop('selected', true)

initialize '#crop-target', ->
  $('#image_crop_style').change(updateCropSize)
  disableOptions()
  updateCropSize()
