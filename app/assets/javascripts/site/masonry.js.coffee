initialize '#images-container', ->
  $(this).imagesLoaded =>
    $('.image-container').fadeIn()
    $(this).masonry
      itemSelector: '.item',
      columnWidth: (containerWidth) -> Math.floor(containerWidth / 5)
