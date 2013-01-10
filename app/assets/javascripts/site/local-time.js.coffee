initialize '.local-time', ->
  $(this).each ->
    date = $(this).data('date')
    date = if date then new Date(date) else new Date
    $(this).text date.format($(this).data('format'))
