#= require date.format.js

initialize 'time:empty', ->
  $(this).each ->
    $(this).attr 'datetime', (__, datetime) ->
      datetime ? (new Date).toISOString()
    datetime = new Date($(this).attr('datetime'))
    format = $(this).data('format')

    $(this).text(datetime.format(format))

    if $(this).data('timestamp')
      # Only show timestamp if the date refers to a time earlier today
      today = new Date()
      today.setHours(0, 0, 0, 0)
      if datetime > today
        $time = $('<span>')
        $time.addClass('timestamp')
        $time.text(datetime.format('h:MM TT'))
        $(this).append(' ').append($time)
