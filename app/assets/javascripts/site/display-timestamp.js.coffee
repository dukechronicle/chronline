initialize 'span[data-timestamp]', ->
  $(this).each ->
    date = new Date($(this).data('timestamp') * 1000)
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
