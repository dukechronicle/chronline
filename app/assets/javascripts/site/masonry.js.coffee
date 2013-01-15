initialize '#images-container', ->
  $(this).imagesLoaded =>
    $(this).masonry
      itemSelector: '.item',
      columnWidth: (containerWidth) -> containerWidth / 3
