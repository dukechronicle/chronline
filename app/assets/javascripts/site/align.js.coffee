window.loadAfterTypekit = (callback) ->
  ->
    execute = () => callback.call(this)
    if $('html').hasClass('wf-active') or $('html').hasClass('wf-inactive')
      execute()
    else
      setTimeout(execute, 300)

truncateArticleLists = ->
  $('.article-list .rounded').each ->
    # check for overflow, the +1 is a hack for IE. Oh IE...
    while $(this)[0].scrollHeight > $(this).outerHeight(false) + 1
      $story = $(this).find('.list-story:last')
      if $story.length > 0
        $story.remove()
      else
        break

truncateTeaser = ->
  $(this).each ->
    while $(this)[0].scrollHeight > $(this).outerHeight(false) + 1
      console.log $(this)[0]
      console.log $(this)[0].scrollHeight
      console.log $(this).outerHeight(false)
      $text = $(this).find('p:last')
      if $text.length > 0
        $text.text((index, text) -> text.replace(/\s+\S*\.*$/, '...'))
      else
        break

pageAlign = ->
  # Iterate through groups in reverse order so nested groups get aligned first
  groups = $(this).get().reverse()
  $(groups).each ->
    # Align inner elements first
    elements = $(this).children('.align-element')
    primary = _.max(elements, (element) ->
      if $(element).data('alignprimary')
        Infinity
      else
        $(element).height()
    )

    for element in elements
      selector = $(element).data('aligntarget')
      target = if selector then $(element).find(selector) else element
      delta = $(primary).height() - $(element).height()
      $(target).height((index, height) -> height + delta)
  truncateArticleLists()  # In case any story lists boxes were made smaller

# This ensures that a container cannot be smaller than its label
verticalAlign = ->
  $(this).each ->
    rounded = $(this).siblings('.rounded')
    rounded.css('min-height', $(this).width() + 'px')


initialize '.vertical-label', loadAfterTypekit(verticalAlign)
initialize '.align-group', loadAfterTypekit(pageAlign)
#initialize  '.article-row .row-article, .block .rounded', loadAfterTypekit(truncateTeaser)
