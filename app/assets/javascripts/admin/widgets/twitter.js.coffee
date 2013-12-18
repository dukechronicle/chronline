initialize '#widget-editor', ->
  TwitterView = Backbone.View.extend
    events:
      'keyup #url': 'update'

    urlPattern: /^https?:\/\/twitter\.com\//

    initialize: (options) ->
      this._handler = _.debounce(_.bind(this.handler, this), 700)

    handler: (url, callback) ->
      if this.urlPattern.test(url)
        callback("{{Twitter:#{url}}}")
      else
        callback("Invalid url!")

    render: ->
      text_field = _.template("<label for='<%= field_id %>'><%= label %></label>
              <input id='<%= field_id %>' type='text'>")
      this.$el.html(text_field
        field_id: 'url'
        label: 'Twitter URL'
      )

    update: (e) ->
      this._handler $(e.target).val(), (tag) ->
        if (tag)
          $('#tag-result').text(tag)

  window.TwitterView = TwitterView
