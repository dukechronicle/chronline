#= require site/templates/topic-response
#= require date.format.js

window.TopicResponseView = Backbone.Marionette.ItemView.extend
  template: JST['site/templates/topic-response']
  tagName: 'li'
  className: 'topic-response'

  events:
    'click .upvote': 'upvote'
    'click .downvote': 'downvote'

  upvote: ->
    @model.upvote()

  downvote: ->
    @model.downvote()

  formatDate: (time) ->
    now = new Date()
    if time.getFullYear() == now.getFullYear() and
      time.getMonth() == now.getMonth() and
      time.getDate() == now.getDate()
        time.format('h:MM TT')
    else
      time.format('ddd, mmm d')

  serializeData: ->
    data = @model.toJSON()
    data['timestamp'] = this.formatDate(new Date(@model.get('created_at')))
    data
