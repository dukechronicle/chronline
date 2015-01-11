window.Team = Backbone.Model.extend
  image: (size) ->
    "//a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/#{this.get('espn_id')}.png?w=#{size}&h=#{size}&transparent=true"

  firstGamePosition: ->
    seeds = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15]
    this.get('region_id') * 8 + Math.floor(seeds.indexOf(this.get('seed')) / 2)

  roundEliminated: (games) ->
    game = games.at(this.firstGamePosition())
    while game?.get('final')
      if game.winner().id == this.id
        game = game.next()
      else
        return game.round()
