pluralize = (word, quantity) ->
  "#{quantity} #{word}" + (if quantity is 1 then '' else 's')

timeText = (milliseconds) ->
  seconds = Math.floor(milliseconds / 1000)
  minutes = Math.floor(seconds / 60)
  hours = Math.floor(minutes / 60)
  days = Math.floor(hours / 24)

  hours = hours % 24
  minutes = minutes % 60
  "#{pluralize('day', days)}, #{pluralize('hour', hours)}, #{pluralize('minute', minutes)}"

displayRemainingTime = ($element, milliseconds) ->
  $element.children('.label').text('Starts In')
  $element.children('.value').text(timeText(milliseconds))

updateGameStats = ($element, startTime) ->
  ->
    milliseconds = startTime - Date.now()
    if milliseconds > 0
      displayRemainingTime($element, milliseconds)

initialize '.game-stats', ->
  startTime = new Date($(this).data('starttime'))
  update = updateGameStats($(this), startTime)
  update()
  setInterval(update, 10000)
  $(this).show()
