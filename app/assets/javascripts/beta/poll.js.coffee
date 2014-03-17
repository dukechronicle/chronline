initialize '.poll-container', ->
  pollId = $(this).find('.poll').data('poll-id')
  poll = new Poll(id: pollId)
  view = new PollView(model: poll, el: '.poll')
