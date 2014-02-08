window.TopicResponse = Backbone.Model.extend
  urlRoot: ->
    fullUrl('api', "/topics/#{this.get('topic_id')}/responses")
