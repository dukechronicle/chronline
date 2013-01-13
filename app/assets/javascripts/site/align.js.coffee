loadAfterTypekit = (callback) ->
  ->
    execute = () => callback.call(this)
    if $('html').hasClass('wf-active') or $('html').hasClass('wf-inactive')
      execute()
    else
      setTimeout(execute, 300)

initialize '.vertical-label', ->
  $(this).each ->
    rounded = $(this).siblings('.rounded')
    rounded.css('min-height', $(this).width() + 'px')
