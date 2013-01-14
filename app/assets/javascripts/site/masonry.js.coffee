initialize '#images-container', ->
  $container = $('#images-container')
  $container.imagesLoaded ->
    $container.masonry({
      itemSelector: '.item',
      columnWidth: (containerWidth) ->
        return containerWidth / 3
    })
    return
