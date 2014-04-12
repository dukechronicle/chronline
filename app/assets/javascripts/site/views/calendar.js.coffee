window.CalendarView = Backbone.View.extend

  events:
    'click .month-block' : 'selectDay'

  initialize: (options) ->
    this.listenTo(@model, 'change', @render) if @model?


  selectDay: (ev) ->
    year = $(ev.currentTarget).data('year')
    month = $(ev.currentTarget).data('month')
    day = $(ev.currentTarget).data('day')
    @collection.date = new Date(year, month-1, day)
    console.log(@collection.date)
    @collection.fetch()

  render: ->
    console.log(@el)
    this