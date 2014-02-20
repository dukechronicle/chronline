#= require site/templates/bracket
#= require site/templates/login

window.BracketView = Backbone.View.extend
  template: JST['site/templates/bracket']

  initialize: (options) ->
    this.listenTo(@model, 'change', @render) if @model?
    @games = options['games']

  render: ->
    @$el.html(@template(bracket: @model))

    @$el.find('.region-left').each ->
      $(this).prepend (new BracketLinesView(flipped: false)).render().el
    @$el.find('.region-right').each ->
      $(this).prepend (new BracketLinesView(flipped: true)).render().el

    if @model?.isNew() and @model?.complete()
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
