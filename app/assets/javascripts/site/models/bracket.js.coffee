window.Bracket = Backbone.Model.extend
  url: ->
    window.location.pathname.replace(/\/new$/, '')

  defaults:
    picks: []

  initialize: ->
    this.set(editing: true) if this.isNew()

  makePick: (game, teamId) ->
    picks = _.clone(this.get('picks'))
    if picks[game.get('position')] != teamId
      this._checkWinner(game, picks)
      picks[game.get('position')] = teamId
      this.set(picks: picks)

  _checkWinner: (game, picks) ->
    unless game.lastRound()
      nextGame = game.next()
      if picks[nextGame.get('position')] == picks[game.get('position')]
        this._checkWinner(nextGame, picks)
        picks[nextGame.get('position')] = undefined

  winnerForGame: (game) ->
    teamId = this.get('picks')[game.get('position')]
    if teamId
      [team1, team2] = this.teamsInGame(game)
      return team1 if team1?.id == teamId
      return team2 if team2?.id == teamId

  teamsInGame: (game) ->
    if game.firstRound()
      [game.team1(), game.team2()]
    else
      [
        this.winnerForGame(game.game1())
        this.winnerForGame(game.game2())
      ]

  complete: ->
    _.compact(this.get('picks')).length == 63

  editable: ->
    tournamentStart = new Date(this.get('tournament').start_date)
    this.get('editable') and Date.now() < tournamentStart

  ##
  # Utility to make testing easier
  #
  _randomPicks: (games) ->
    games.each (game) =>
      i = Math.floor(Math.random() * 2)
      winner = this.teamsInGame(game)[i]
      this.makePick(game, winner.id)
