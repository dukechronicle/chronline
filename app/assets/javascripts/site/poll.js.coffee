initialize '.poll-container', ->
  pollJSON = $(this).find('.poll').data('poll')
  poll = new Poll(pollJSON)
  view = new PollView(model: poll, el: '.poll')
  view.render()
