initialize '.featured-selectable', ->
  $slide = $('.slide:visible')
  $slide.css('display', 'block')
  $(this).on 'click', '.selector a', (e) ->
    e.preventDefault()
    $lastSlide = $slide
    $slide = $('.slide').eq($(this).data('index'))
    $lastSlide.fadeOut -> $slide.fadeIn()
