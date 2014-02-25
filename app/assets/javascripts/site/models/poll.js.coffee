window.Poll = Backbone.Model.extend
  urlRoot: ->
    "/polls"

  vote: (choice_id) ->
    $.ajax
      method: 'POST'
      url: "#{this.urlRoot('vote')}/#{@id}/vote",
      data: {choice: choice_id}
    choice_id = parseInt(choice_id)
    choice = _.find(this.get('choices'), (c) -> c.id == choice_id)
    choice.votes += 1
    this.set(voted: true)
