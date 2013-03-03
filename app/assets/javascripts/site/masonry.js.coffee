initialize '#images-container', ->
  $(this).imagesLoaded =>
    $(this).masonry
      itemSelector: '.item',
      columnWidth: (containerWidth) -> Math.floor(containerWidth / 5)

    $images = $(this).find('.image-item')
    $images.hide()
    $images.css('visibility', 'visible')
    $images.each ->
      setTimeout((=> $(this).fadeIn()), Math.random() * 500)
