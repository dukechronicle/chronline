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

  $('input#topic_response_content').on 'focus', (e) ->
    $textArea = $('textarea#topic_response_content')
    $(this).hide()
    $textArea.show()
    $textArea.focus()
  $('textarea#topic_response_content').on 'focusout', (e) ->
    unless $(this).val()
      $textField = $('input#topic_response_content')
      $(this).hide()
      $textField.show()

  $('#new_topic_response').on 'ajax:before', (e) ->
    unless $('#recaptcha_widget_div').is(':visible')
      $('#recaptcha_widget_div').slideDown()
      return false
    unless $('#recaptcha_response_field').val()
      showError('Enter the text in the reCaptcha image')
      false
    unless $('textarea#topic_response_content').val()
      showError('Submission may not be empty')
      false
  $('#new_topic_response').on 'ajax:success', (e, data, status, xhr) ->
    location.reload()
  $('#new_topic_response').on 'ajax:error', (e, data, status, xhr) ->
    if data.status == 403
      showError('reCaptcha incorrect. Try again.')
    else
      showError('Sorry, an error occurred')

showError = (message) ->
  $('#topic_response_error').text(message).show()
