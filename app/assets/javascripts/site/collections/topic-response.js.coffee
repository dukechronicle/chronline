#= require site/models/topic-response

TopicResponse.Collection = Backbone.Collection.extend
  model: TopicResponse

  url: ->
    fullUrl('api', "/topics/#{@topicId}/responses")

  initialize: (_models, options) ->
    @topicId = options.topicId
