window.Game = Backbone.Model.extend
  team1: ->
    new Team(this.get('team1')) if this.get('team1')

  team2: ->
    new Team(this.get('team2')) if this.get('team2')

  game1: ->
    position = this._firstGameInPreviousRound() +
      2 * (this.get('position') - this._firstGameInRound())
    @collection.at(position)

  game2: ->
    position = this._firstGameInPreviousRound() + 1 +
      2 * (this.get('position') - this._firstGameInRound())
    @collection.at(position)

  next: ->
    unless this.lastRound()
      position = this._firstGameInNextRound() +
        Math.floor((this.get('position') - this._firstGameInRound()) / 2)
      @collection.at(position)

  round: ->
    position = this.get('position')
    switch
      when position < 32 then 1
      when position < 48 then 2
      when position < 56 then 3
      when position < 60 then 4
      when position < 62 then 5
      else 6

  _firstGameInPreviousRound: ->
    64 - Math.pow(2, 8 - this.round())

  _firstGameInRound: ->
    64 - Math.pow(2, 7 - this.round())

  _firstGameInNextRound: ->
    64 - Math.pow(2, 6 - this.round())

  winner: ->
    if this.get('final')
      if this.get('score1') > this.get('score2')
        this.team1()
      else
        this.team2()

  firstRound: ->
    this.get('position') < 32

  lastRound: ->
    this.get('position') == 62

  formatStartTime: (format) ->
    (new Date(this.get('start_time'))).format(format)
