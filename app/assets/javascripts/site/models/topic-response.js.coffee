window.TopicResponse = Backbone.Model.extend
  urlRoot: ->
    fullUrl('api', "/topics/#{this.get('topic_id')}/responses")

  upvote: ->
    $.post("#{this.urlRoot()}/#{this.id}/upvote")
    count = this.get('upvotes')
    if this.get('upvoted')
      this.set(upvoted: false, upvotes: count - 1)
    else
      this.set(upvoted: true, upvotes: count + 1)

  downvote: ->
    $.post("#{this.urlRoot()}/#{this.id}/downvote")
    count = this.get('downvotes')
    if this.get('downvoted')
      this.set(downvoted: false, downvotes: count - 1)
    else
      this.set(downvoted: true, downvotes: count + 1)

  report: ->
    $.post("#{this.urlRoot()}/#{this.id}/report")
    this.set(reported: true)
