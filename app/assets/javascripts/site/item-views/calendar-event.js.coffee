window.CalendarEventView = Backbone.Marionette.ItemView.extend
  template: JST('sites/templates/calendar-event')
  tagname: 'li'
  className: 'month-block'

  events:
    'click .day-block': 'change_day'

  intialize: ->
    this.listenTo(@model, 'change', @render)

  change_day: ->
    @model.day = 5