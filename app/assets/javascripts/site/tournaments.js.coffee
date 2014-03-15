initialize '#bracket.tournament', ->
  games = new Game.Collection($(this).data('games'))
  view = new BracketView
    games: games
    userBracket: $(this).data('user-bracket')
    el: $(this)[0]
  view.render()

initialize '#bracket.bracket', ->
  games = new Game.Collection($(this).data('games'))
  bracket = new Bracket($(this).data('bracket'))
#  bracket._randomPicks(games)
  (new BracketView(model: bracket, games: games, el: $(this)[0])).render()
