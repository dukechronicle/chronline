imageSelector =
  open: (callback) ->
    page = 1
    html = _.template(IMAGE_SELECT_TEMPLATE, {})
    $imageSelect = $(html)

    $imageSelect.on 'click', '#next', ->
      loadImages.call($imageSelect, page++)
    $imageSelect.find('.modal-body .images').on 'click', 'img', ->
      $imageSelect.modal('hide')
      callback($(this).data('image'))

    $imageSelect.modal('show').on('hidden', -> $(this).remove())
    loadImages.call($imageSelect, page++)
    $imageSelect

loadImages = (page) ->
  data = {limit: 35, page: page}
  $.get(fullUrl('api', '/images'), data, addImages.bind(this))

addImages = (images) ->
  $imagesContainer = $(this).find('.modal-body .images')
  for image in images
    $imageTag = $("<img src=\"#{image.thumbnail_url}\" />")
    $imageTag.data('image', image)
    $imagesContainer.append($imageTag)

IMAGE_SELECT_TEMPLATE = """
<div id="image-select" class="modal hide fade">
  <div class="modal-header">
    <button class="close" type="button" data-dismiss="modal" aria-hidden="true">
      &times;
    </button>
    <h3 class="title">Select Image</h3>
  </div>
  <div class="modal-body">
    <div class="images clearfix" />
    <a id="next" href="#">More Images</a>
  </div>
</div>
"""

window.imageSelector = imageSelector
