initialize 'span[data-timestamp]', ->
  $(this).each ->
    date = new Date($(this).data('timestamp') * 1000)
    format = $(this).data('format')
    if not format?
      today = new Date()
      today.setHours(0, 0, 0, 0)
      format = 'mmmm d, yyyy'
      format += ' h:MM TT Z' if date > today
    $(this).text(date.format(format))
