window.Poll = Backbone.Model.extend
  urlRoot: "/polls"

  vote: (choiceId) ->
    $.ajax
      method: 'POST'
      url: "#{this.url()}/vote",
      data: {choice: choiceId}
    .done (data) =>
      this.set(data)

  calculatePercentages: () ->
    vote_sum = _.reduce(this.get('choices'), (memo, choice) ->
      memo + choice.votes
    , 0)
    _.each this.get('choices'), (choice) ->
      choice.percentage = 100 * choice.votes/vote_sum
