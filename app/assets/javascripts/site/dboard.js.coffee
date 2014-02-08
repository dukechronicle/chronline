initialize '#discussion-board', ->
  topicId = $(this).find('.topic-container').data('id')
  console.log topicId
  (new TopicResponse.Collection([], topicId: topicId)).fetch
    success: (responses) ->
      console.log responses

  $('#new_topic_reponse').on 'ajax:success', (e, data, status, xhr) ->
    console.log status
