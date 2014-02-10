window.TopicResponse = Backbone.Model.extend
  urlRoot: ->
    fullUrl('api', "/topics/#{this.get('topic_id')}/responses")

  upvote: ->
    $.post("#{this.urlRoot()}/#{this.id}/upvote")
    count = this.get('upvotes')
    if this.get('upvoted')
      this.set(upvoted: false, count - 1)
    else
      this.set(upvoted: true, count + 1)

  downvote: ->
    $.post("#{this.urlRoot()}/#{this.id}/downvote")

  report: ->
    $.post("#{this.urlRoot()}/#{this.id}/report")
