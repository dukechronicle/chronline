initialize '.featured-selectable', ->
  $slide = $('.slide:not(.hidden)')
  console.log $slide
  $(this).on 'click', 'a.selector', (e) ->
    e.preventDefault()
    $lastSlide = $slide
    $slide = $('.slide').eq($(this).data('index'))
    $lastSlide.fadeOut -> $slide.fadeIn()
