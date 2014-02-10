#= require site/item-views/topic-response

window.TopicResponsesView = Backbone.Marionette.CollectionView.extend
  itemView: TopicResponseView

  events:
    'scroll': 'scroll'

  scroll: ->
    if not @_fetching and (@$el.height() + @$el.scrollTop() == @el.scrollHeight)
      @_fetching = true
      @collection.nextPage
        success: (collection, response) =>
          this.render()
          @_fetching = false if response.length > 0
