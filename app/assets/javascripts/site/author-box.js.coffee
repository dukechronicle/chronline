selected = $([])
selectedNav = $([])


showAuthor = (index) ->
  selectedNav.removeClass('selected')
  selected.hide()

  selectedNav = $('.author-list a').eq(index)
  selected = $('.author').eq(index)

  selectedNav.addClass('selected')
  selected.show()
  truncateArticleList()

truncateArticleList = loadAfterTypekit ->
  while selected.height() > selected.parent().height()
    selected.find('.list-story:last-child').remove()

initialize '.author-box', ->
  $('.author-list').on 'click', 'a', (e) ->
    e.preventDefault()
    showAuthor($(this).index())

  # randomly select a columnist
  randomIndex = Math.floor(Math.random() * $('.author-list a').size())
  showAuthor(randomIndex)
