initialize '#images-container', ->
  $(this).imagesLoaded =>
    $(this).masonry
      itemSelector: '.item',
      columnWidth: (containerWidth) -> Math.floor(containerWidth / 5)
