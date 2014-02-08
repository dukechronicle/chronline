#= require site/models/topic-response

TopicResponse.Collection = Backbone.Collection.extend
  url: ->
    fullUrl('api', "/topics/#{@topicId}/responses")

  initialize: (_models, options) ->
    @topicId = options.topicId
