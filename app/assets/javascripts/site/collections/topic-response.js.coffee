#= require site/models/topic-response

TopicResponse.Collection = Backbone.Collection.extend
  urlRoot: ->
    fullUrl('api', "/topics/#{this.get('topic_id')}/responses")
