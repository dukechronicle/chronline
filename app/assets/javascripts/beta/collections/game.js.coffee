#= require beta/models/game

Game.Collection = Backbone.Collection.extend
  model: Game

  comparator: 'position'

  inRound: (round, region) ->
    switch region
      when 0
        start = 64 - Math.pow(2, 7 - round)
      when 1
        start = 64 - Math.pow(2, 7 - round) + Math.pow(2, 4 - round)
      when 2
        start = 64 - Math.pow(2, 7 - round) + Math.pow(2, 5 - round)
      when 3
        start = 64 - Math.pow(2, 6 - round) - Math.pow(2, 4 - round)
    this.slice(start, start + Math.pow(2, 4 - round))
