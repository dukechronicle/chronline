initialize '#bracket.tournament', ->
  tournament = $(this).data('tournament')
  games = new Game.Collection(tournament.games)
  view = new BracketView
    tournament: tournament
    games: games
    userBracket: $(this).data('user-bracket')
    el: $(this)[0]
  view.render()

initialize '#bracket.bracket', ->
  bracket = new Bracket($(this).data('bracket'))
  tournament = bracket.get('tournament')
  games = new Game.Collection(tournament.games)
#  bracket._randomPicks(games)
  view = new BracketView
    model: bracket
    tournament: tournament
    games: games
    el: $(this)[0]
  view.render()
