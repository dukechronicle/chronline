initialize '#bracket.tournament', ->
  tournament = new Tournament($(this).data('tournament'))
  view = new BracketView
    tournament: tournament
    games: tournament.games()
    userBracket: $(this).data('user-bracket')
    el: $(this)[0]
  view.render()

initialize '#bracket.bracket', ->
  bracket = new Bracket($(this).data('bracket'))
  tournament = new Tournament(bracket.get('tournament'))
  games = tournament.games()
#  bracket._randomPicks(games)
  view = new BracketView
    model: bracket
    tournament: tournament
    games: games
    el: $(this)[0]
  view.render()
