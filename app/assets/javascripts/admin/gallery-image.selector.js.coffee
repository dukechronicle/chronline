#= require eventEmitter/EventEmitter.min.js
#= require eventie/eventie.js
#= require imagesloaded/imagesloaded.js
#= require imagesloaded/imagesloaded.js
#= require site/masonry.js

$container = $('.image-selector')
imagesLoaded( $container, ->
  $container.masonry({
    itemSelector: ".gallery-image",
  })
  $(".gallery-image").click( ->
    $(".gallery-image.selected").removeClass("selected")
    $(this).addClass("selected")
    $("#gallery_primary_image_id").val($(this).data("pid"))
  )
)
