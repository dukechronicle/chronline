initialize '.featured-selectable', ->
  $slide = $('.slide:visible')
  $slide.css('display', 'block')
  $('.selector a[data-index=0]').addClass('selected')
  $(this).on 'click', '.selector a', (e) ->
    e.preventDefault()
    $lastSlide = $slide
    $('.selector a').removeClass('selected')
    $(this).addClass('selected')
    $slide = $('.slide').eq($(this).data('index'))
    $lastSlide.fadeOut -> $slide.fadeIn()
