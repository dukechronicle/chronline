tinymce.PluginManager.add('image', (editor) ->
  addImages = ($imageSelect, $imagePicker, $handler, images) ->
    for image in images
      $imageTag = $("<img src=\"#{image.thumbnail_url}\" />")
      $imageSelect.find('.modal-body .images').append($imageTag)
      do (image) ->
        $imageTag.click ->
          $handler($imagePicker, image)

  insertImage = ($articleBody, image) ->
    tag = "{{Image:#{image.id}}}"
    tinyMCE.activeEditor.execCommand('mceInsertContent', false, tag)
    setVisibilities($articleBody)
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

  loadImages = ($imagePicker, $handler,  page=1) ->
    ->
      data = {limit: 35, page: page++}
      $.get fullUrl('api', '/images'), data, (images) =>
        addImages($(this), $imagePicker, $handler, images)

  openMenu = ->
    articleBody = $('textarea#article_body')
    imageSelect = createModal()
    imageSelect.loadImages = loadImages(articleBody, insertImage)
    imageSelect.loadImages()

  editor.addButton('image', {
    icon: 'image',
    tooltip: 'Insert image',
    onclick: openMenu,
    stateSelector: 'img:not([data-mce-object])'
  })
  editor.addMenuItem('image', {
    icon: 'image',
    text: 'Insert image',
    onclick: openMenu,
    context: 'insert',
    prependToContext: true
  })
)
