#= require site/templates/poll-form
#= require site/templates/poll-results

window.PollView = Backbone.Marionette.ItemView.extend
  initialize: ->
    this.listenTo(@model, 'change', @render)
    @model.fetch()

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
    poll_choices = @$el.find('.poll-choice')
    vote_sum = _.reduce(poll_choices, (memo, choice) ->
      memo + parseInt($(choice).attr('data-votes'))
    , 0)

    _.each(poll_choices, (choice) ->
      choice = $(choice)
      percentage = 100 * choice.attr('data-votes')/vote_sum
      choice.find('.poll-choice-bar')
        .animate({width: "#{percentage}%"}, 500)
      choice.find('.choice-percentage').text("#{percentage.toFixed(1)}%")
    )
