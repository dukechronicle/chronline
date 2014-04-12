#= require site/models/event

Event.Collection = Backbone.Collection.extend
  model: Event

  url: ->
    fullUrl('api', "/events/#{@date.getFullYear()}/#{@date.getMonth()+1}/#{@date.getDate()}")

  initialize: (_models, options) ->
    @filter = 'all'
    @date = new Date()
