#= require beta/views/game
#= require beta/templates/bracket-game

window.BracketGameView = GameView.extend
  template: JST['beta/templates/bracket-game']

  events:
    'dblclick': 'showPreview'
    'click': 'showPreviewUnlessEditing'
    'click .team-selectable.team-1': 'selectTeam1'
    'click .team-selectable.team-2': 'selectTeam2'

  initialize: (options) ->
    @bracket = options.bracket

  teams: ->
    @bracket.teamsInGame(@model)

  showPreviewUnlessEditing: ->
    this.showPreview() unless this.get('editing')

  selectTeam1: ->
    [team1, team2] = this.teams()
    @bracket.makePick(@model, team1.id) if team1?

  selectTeam2: ->
    [team1, team2] = this.teams()
    @bracket.makePick(@model, team2.id) if team2?

  render: ->
    [team1, team2] = this.teams()
    winner = @bracket.winnerForGame(@model)
    actualWinner = @model.winner()
    selectedClass =
      if actualWinner? and actualWinner.id == winner.id
        'selected correct'
      else if actualWinner?
        'selected incorrect'
      else
        'selected'
    @$el.html(
      @template(
        game: @model
        winner: @bracket.winnerForGame(@model)
        selectable: @bracket.get('editing')
        team1: team1
        team2: team2
        selectedClass: selectedClass
      )
    )
    this
