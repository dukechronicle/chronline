initialize '#bracket.tournament', ->
  games = new Game.Collection($(this).data('games'))
  (new BracketView(games: games, el: $(this)[0])).render()
