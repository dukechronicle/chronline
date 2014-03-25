window.Event = Backbone.Model.extend
  urlRoot: ->
    fullUrl('api', "/events/#{this.get('event_year')}/#{this.get('event_month')}/#{this.get('event_day')})