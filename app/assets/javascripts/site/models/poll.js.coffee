window.Poll = Backbone.Model.extend
  urlRoot: "/polls"

  vote: (choice_id) ->
    $.ajax
      method: 'POST'
      url: "#{this.url()}/vote",
      data: {choice: choice_id}
    choice_id = parseInt(choice_id)
    choice = _.find(this.get('choices'), (c) -> c.id == choice_id)
    choice.votes += 1
    this.set(voted: true)
    this.sortChoices()

  sortChoices: () ->
    this.set('choices', _.sortBy(this.get('choices'), 'votes').reverse())

  calculatePercentages: () ->
    vote_sum = _.reduce(this.get('choices'), (memo, choice) ->
      memo + choice.votes
    , 0)
    _.each this.get('choices'), (choice) ->
      choice.percentage = 100 * choice.votes/vote_sum
