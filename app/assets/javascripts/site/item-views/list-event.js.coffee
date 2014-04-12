#= require site/templates/list-event

window.ListEventView = Backbone.Marionette.ItemView.extend
  template: JST['site/templates/list-event']
  tagname: 'li'
  className: 'list-event'