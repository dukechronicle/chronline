initialize '#discussion-board', ->
  (new TopicResponse.Collection()).fetch
    success: (responses) ->
      console.log responses
