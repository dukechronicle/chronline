#= require site/templates/bracket

window.BracketView = Backbone.View.extend
  template: JST['site/templates/bracket']

  events:
    'click .done': 'save'

  initialize: (options) ->
    this.listenTo(@model, 'change', @render) if @model?
    @games = options['games']

  save: ->
    token = $("meta[name='csrf-token']").attr('content')
    @model.save {},
      headers:
        'X-CSRF-Token': token
      success: (model, response, options) ->
        slug = model.get('tournament').slug
        window.location = "/tournaments/#{slug}/brackets/#{model.id}"
      error: (model, response, options) ->
        if response.status == 401
          console.log('Please login')
          # Prompt for login

  render: ->
    @$el.html(@template(bracket: @model))

    @$el.find('.region-left').each ->
      $(this).prepend (new BracketLinesView(flipped: false)).render().el
    @$el.find('.region-right').each ->
      $(this).prepend (new BracketLinesView(flipped: true)).render().el

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
