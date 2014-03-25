window.CalendarEventsList = Backbone.Marionette.CollectionView.extend
  itemView: CalendarEventView

window.EventsList = Backbone.Marionette.CollectionView.extend
  itemView: ListEventView