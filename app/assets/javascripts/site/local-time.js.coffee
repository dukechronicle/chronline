initialize '.local-time', ->
  $(this).each ->
    timestamp = $(this).data('timestamp')
    date = if timestamp then new Date(timestamp * 1000) else new Date
    format = $(this).data('format')
    $(this).text(date.format(format ? 'mmmm d, yyyy'))

    if not format?
      today = new Date()
      today.setHours(0, 0, 0, 0)
      if date > today
        $time = $('<span>')
        $time.addClass('timestamp')
        $time.text(date.format('h:MM TT'))
        console.log($time)
        $(this).append(' ').append($time)
