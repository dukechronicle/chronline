#= require site/templates/poll-form
#= require site/templates/poll-results

window.PollView = Backbone.Marionette.ItemView.extend
  initialize: ->
    this.listenTo(@model, 'change', @render)

  events:
    'submit form': 'submit'

  getTemplate: ->
    if @model.get('voted')
      template = JST['site/templates/poll-results']
    else
      template = JST['site/templates/poll-form']

  onRender: ->
    if @model.get('voted')
      this._renderBars()

  submit: (e) ->
    e.preventDefault()
    chosen_choice = @$el.find('input[name=choice]:checked').val()
    if chosen_choice
      @model.vote(chosen_choice)

  _renderBars: ->
    @model.calculatePercentages()
    choice_elements = @$el.find('.poll-choice')
    els_with_choices = _.zip(choice_elements, @model.get('choices'))

    _.each(els_with_choices, (el_choice_pair) ->
      choice_el = $(el_choice_pair[0])
      choice = el_choice_pair[1]
      choice_el.find('.poll-choice-bar')
        .animate({width: "#{choice.percentage}%"}, 500)
      choice_el.find('.choice-percentage')
        .text("#{choice.percentage.toFixed(1)}%")
    )
