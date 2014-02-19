#= require site/templates/bracket-game

window.BracketGameView = Backbone.View.extend
  template: JST['site/templates/bracket-game']

  className: 'game'

  events:
    'click .team-selectable.team-1': 'selectTeam1'
    'click .team-selectable.team-2': 'selectTeam2'

  initialize: (options) ->
    @bracket = options.bracket

  selectTeam1: ->
    [team1, team2] = @bracket.teamsInGame(@model)
    @bracket.makePick(@model, team1.id) if team1?

  selectTeam2: ->
    [team1, team2] = @bracket.teamsInGame(@model)
    @bracket.makePick(@model, team2.id) if team2?

  render: ->
    [team1, team2] = @bracket.teamsInGame(@model)
    @$el.html(
      @template(
        game: @model
        winner: @bracket.winnerForGame(@model)
        selectable: @bracket.isNew()
        team1: team1
        team2: team2
      )
    )
    this
