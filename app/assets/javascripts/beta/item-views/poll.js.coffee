#= require beta/templates/poll-form
#= require beta/templates/poll-results

window.PollView = Backbone.Marionette.ItemView.extend
  initialize: ->
    @model.fetch()
    this.listenTo(@model, 'change', @render)

  events:
    'submit form': 'submit'

  getTemplate: ->
    if @model.get('voted')
      template = JST['beta/templates/poll-results']
    else
      template = JST['beta/templates/poll-form']

  onRender: ->
    if @model.get('voted')
      this._renderBars()

  submit: (e) ->
    e.preventDefault()
    chosenChoice = @$el.find('input[name=choice]:checked').val()
    if chosenChoice
      @model.vote(chosenChoice)

  _renderBars: ->
    @model.calculatePercentages()
    choiceElements = @$el.find('.poll-choice')
    elsWithChoices = _.zip(choiceElements, @model.get('choices'))

    _.each(elsWithChoices, (elChoicePair) ->
      choiceEl = $(elChoicePair[0])
      choice = elChoicePair[1]
      choiceEl.find('.poll-choice-bar')
        .animate({width: "#{choice.percentage}%"}, 500)
      choiceEl.find('.choice-percentage')
        .text("#{choice.percentage.toFixed(1)}%")
    )
