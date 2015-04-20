#= require eventEmitter/EventEmitter
#= require eventie/eventie
#= require doc-ready/doc-ready
#= require get-style-property/get-style-property
#= require get-size/get-size
#= require jquery-bridget/jquery.bridget
#= require matches-selector/matches-selector
#= require fizzy-ui-utils/utils
#= require outlayer/item
#= require outlayer/outlayer
#= require jquery-masonry/masonry

initialize '#images-container', ->
  $(this).masonry
    itemSelector: '.item',
    columnWidth: Math.floor($(this).width() / 5)

  $images = $(this).find('.image-item')
  $images.hide()
  $images.css('visibility', 'visible')
  $images.each ->
    setTimeout((=> $(this).fadeIn()), Math.random() * 500)
