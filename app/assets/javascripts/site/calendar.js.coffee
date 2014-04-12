initialize '#events-view', ->
  window.collection = new Event.Collection()
  list_view = new EventsList(
    el: $(this)
    collection: collection
  )
  calendar_view = new CalendarView(
    el: $(".outer_calendar")
    collection: collection
  )
  list_view.render()
  calendar_view.render()
  collection.fetch()
