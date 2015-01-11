#= require beta/templates/bracket

window.BracketView = Backbone.View.extend
  template: JST['beta/templates/bracket']

  events:
    'click .edit': 'edit'
    'click .done': 'save'

  initialize: (options) ->
    this.listenTo(@model, 'change', @render) if @model?
    @games = options.games
    @tournament = options.tournament
    @userBracket = options.userBracket

  edit: ->
    @model.set(editing: true)

  save: ->
    @model.save {},
      success: =>
        @model.set(editing: false)

  render: ->
    @$el.html(
      @template(
        tournament: @tournament
        bracket: @model
        userBracket: @userBracket
      )
    )

    @$el.find('.region-0, .region-1').each ->
      $(this).prepend (new BracketLinesView(flipped: false)).render().el
    @$el.find('.region-2, .region-3').each ->
      $(this).prepend (new BracketLinesView(flipped: true)).render().el

    if @model?.get('editing')
      $form = $('#new_tournament_bracket').clone()
      $form.find('#tournament_bracket_picks').val(
        JSON.stringify(@model.get('picks'))
      )
      @$el.find('.actions').append($form)

    subview =
      if @model?
        BracketGameView
      else
        GameView

    for region in [0..3]
      for round in [1..4]
        @$el.find(".region-#{region} .round-#{round}").append(
          @games.inRound(round, region).map (game) =>
            (new subview(model: game, bracket: @model)).render().el
        )
    for position in [60..62]
      gameView = new subview(model: @games.at(position), bracket: @model)
      @$el.find(".game-#{position + 1}").append(gameView.render().el)

    this
