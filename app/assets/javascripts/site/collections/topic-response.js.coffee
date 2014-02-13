#= require site/models/topic-response

TopicResponse.Collection = Backbone.Collection.extend
  model: TopicResponse

  url: ->
    fullUrl('api', "/topics/#{@topicId}/responses")

  initialize: (_models, options) ->
    @topicId = options.topicId
    @page = 1

  nextPage: (options) ->
    options.data = options.data ? {}
    options.data['page'] = @page
    options['remove'] = false
    @page = @page + 1
    this.fetch(options)
