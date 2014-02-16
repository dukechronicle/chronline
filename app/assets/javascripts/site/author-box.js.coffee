selected = $([])
selectedNav = $([])


showSelection = (index) ->
  selectedNav.removeClass('selected')
  selected.hide()

  selectedNav = $('.selectors a').eq(index)
  selected = $('.selection').eq(index)

  selectedNav.addClass('selected')
  selected.show()

  columnistsHeight = $('.selectors a').parent().height()+8
  selected.closest('.multiplexer').height(Math.max(columnistsHeight, selected.height()))

initialize '.multiplexer', ->
  $('.selectors').on 'click', 'a', (e) ->
    e.preventDefault()
    showSelection($(this).index())

  # randomly select a columnist
  randomIndex = Math.floor(Math.random() * $('.selectors a').size())
  showSelection(randomIndex)
