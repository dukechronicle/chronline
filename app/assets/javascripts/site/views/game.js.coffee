#= require site/templates/game

window.GameView = Backbone.View.extend
  template: JST['site/templates/game']

  className: 'game'

  render: ->
    [team1, team2] = [@model.team1(), @model.team2()]
    @$el.html(
      @template(
        game: @model
        team1: team1
        team2: team2
      )
    )
    this
