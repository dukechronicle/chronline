initialize '#discussion-board', ->
  topicId = $(this).find('.topic-container').data('id')
  responses = new TopicResponse.Collection([], topicId: topicId)
  responses.fetch
    success: =>
      view = new TopicResponsesView(
        collection: responses
        el: $(this).find('.responses')[0]
      )
      view.render()

  $('#new_topic_reponse').on 'ajax:success', (e, data, status, xhr) ->
    console.log data
    console.log status
  $('#new_topic_reponse').on 'ajax:error', (e, data, status, xhr) ->
    console.log data
    console.log status
