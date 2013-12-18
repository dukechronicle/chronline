initialize '#widget-editor', ->
  InstagramView = Backbone.View.extend
    events:
      'keyup #url': 'update'

    urlPattern: /^https?:\/\/instagram\.com\/p\/([a-zA-Z0-9]+)/

    initialize: (options) ->
      this._handler = _.debounce(_.bind(this.handler, this), 700)

    handler: (url, callback) ->
      match = this.urlPattern.exec(url)
      if match
        callback("{{Instagram:#{match[1]}}}")
      else
        callback()

    render: ->
      text_field = _.template("<label for='<%= field_id %>'><%= label %></label>
              <input id='<%= field_id %>' type='text'>")
      this.$el.html(text_field
        field_id: 'url'
        label: 'Instagram URL'
      )

    update: (e) ->
      this._handler $(e.target).val(), (tag) ->
        if (tag)
          $('#tag-result').text(tag)

  window.InstagramView = InstagramView
