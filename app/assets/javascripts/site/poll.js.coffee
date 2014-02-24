initialize '.poll-container', ->
  pollId = $(this).find('.poll').data('id')
  view = new PollView(id: pollId, el: '.poll')
