initialize '#bracket.tournament', ->
  games = new Game.Collection($(this).data('games'))
  (new BracketView(games: games, el: $(this)[0])).render()


initialize '#bracket.bracket', ->
  games = new Game.Collection($(this).data('games'))
  bracket = new Bracket()
  bracket._randomPicks(games)
  (new BracketView(model: bracket, games: games, el: $(this)[0])).render()
