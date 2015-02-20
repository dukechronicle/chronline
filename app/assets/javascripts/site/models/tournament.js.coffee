window.Tournament = Backbone.Model.extend
  started: ->
    Date.now() > new Date(this.get('start_date'))

  games: ->
    new Game.Collection(this.get('games'))
