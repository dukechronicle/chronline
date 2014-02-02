initialize '.poll-results', ->
  poll_choices = $(this).find('.poll-choice')
  vote_sum = _.reduce(poll_choices, (memo, choice) ->
    memo + parseInt($(choice).attr('data-votes'))
  , 0)

  _.each(poll_choices, (choice) ->
    choice = $(choice)
    percentage = 100 * choice.attr('data-votes')/vote_sum
    choice.find('.poll-choice-bar')
      .animate({width: "#{percentage}%"}, 500)
    choice.find('.choice-percentage').text("#{percentage.toFixed(1)}%")
  )
