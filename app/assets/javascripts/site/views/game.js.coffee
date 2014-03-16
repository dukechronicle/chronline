#= require site/templates/game
#= require site/templates/game-preview

window.GameView = Backbone.View.extend
  template: JST['site/templates/game']

  className: 'game'

  events:
    'dblclick': 'showPreview'

  showPreview: ->
    template = JST['site/templates/game-preview']
    $dialog = $('<div>').attr('id', 'dialog')
    $dialog.html template(
      game: @model
      team1: @model.team1()
      team2: @model.team2()
    )
    $dialog.dialog
      modal: true
      width: '900px'
      close: -> $(this).remove()

  render: ->
    [team1, team2] = [@model.team1(), @model.team2()]
    @$el.html(
      @template(
        game: @model
        team1: team1
        team2: team2
      )
    )
    this
