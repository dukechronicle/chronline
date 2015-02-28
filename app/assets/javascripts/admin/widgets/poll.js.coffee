initialize '#widget-editor', ->
  PollView = Backbone.View.extend
    events:
      'keyup #pollId': 'update'

    render: ->
      text_field = _.template("<label for='<%= field_id %>'><%= label %></label>
              <input id='<%= field_id %>' type='text'>")
      this.$el.html(text_field
        field_id: 'pollId'
        label: 'Poll ID'
      )

    update: (e) ->
      id = $(e.target).val()
      $('#tag-result').text("{{Poll:#{id}}}")

  window.PollView = PollView

