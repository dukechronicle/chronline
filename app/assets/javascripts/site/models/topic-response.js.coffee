window.TopicResponse = Backbone.Model.extend
  urlRoot: ->
    fullUrl('api', "/topics/#{this.get('topic_id')}/responses")

  upvote: ->
    this.request('downvote')
    count = this.get('upvotes')
    if this.get('upvoted')
      this.set(upvoted: false, upvotes: count - 1)
    else
      this.set(upvoted: true, upvotes: count + 1)

  downvote: ->
    this.request('downvote')
    count = this.get('downvotes')
    if this.get('downvoted')
      this.set(downvoted: false, downvotes: count - 1)
    else
      this.set(downvoted: true, downvotes: count + 1)

  report: ->
    this.request('downvote')
    this.set(reported: true)

  request: (action) ->
    $.ajax
      method: 'POST'
      url: "#{this.urlRoot()}/#{this.id}/#{action}"
      xhrFields:
        withCredentials: true
