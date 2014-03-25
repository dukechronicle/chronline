Event-Calendar.Collection = Backbone.Collection.extend
  model: Event

  url: ->
    fullUrl('api', "/events/#{@eventYear}/#{@eventMonth}/#{@eventDay}")

  initialize: (_models, options) ->
    @eventYear = 2014
    @eventMonth = 3;
    @eventDay = 15;