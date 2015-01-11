#= require beta/templates/game
#= require beta/templates/game-preview

window.GameView = Backbone.View.extend
  template: JST['beta/templates/game']

  className: 'game'

  events:
    'click': 'showPreview'

  teams: ->
    [@model.team1(), @model.team2()]

  showPreview: ->
    [team1, team2] = this.teams()
    if team1? and team2?
      template = JST['beta/templates/game-preview']
      $dialog = $('<div>').attr('id', 'dialog')
      $dialog.html template(
        game: @model
        team1: team1
        team2: team2
      )
      $dialog.dialog
        modal: true
        width: '900px'
        close: -> $(this).remove()

  render: ->
    [team1, team2] = this.teams()
    @$el.html(
      @template(
        game: @model
        team1: team1
        team2: team2
      )
    )
    this
