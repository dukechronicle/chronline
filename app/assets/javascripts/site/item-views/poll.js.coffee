#= require site/templates/poll-form
#= require site/templates/poll-results

window.PollView = Backbone.Marionette.View.extend
  className: 'poll'
  urlRoot: (action) ->
    action = action || ''
    fullUrl('www', "/polls/#{@id}/#{action}")

  initialize: ->
    this.request()

  events:
    'submit form': 'submit'

  render: (attrs) ->
    if attrs.voted
      template = JST['site/templates/poll-results']
    else
      template = JST['site/templates/poll-form']
    @$el.html(template(
      title: attrs.poll.title,
      description: attrs.poll.description,
      choices: attrs.choices
    ))
    if attrs.voted
      this._renderBars()

  request: ->
    $.getJSON this.urlRoot(), (data) =>
      this.render(data)

  submit: (e) ->
    e.preventDefault()
    token = $("meta[name='csrf-token']").attr('content')
    $form = $(@$el.find('form'))
    $.ajax(
      method: 'POST'
      url: this.urlRoot('vote'),
      data: $form.serialize()
      headers:
        'X-CSRF-Token': token
      xhrFields:
        withCredentials: true
    ).done (data) =>
      this.render(data)

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
