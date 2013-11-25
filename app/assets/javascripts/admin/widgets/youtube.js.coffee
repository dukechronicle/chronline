initialize '#widget-editor', ->
  YoutubeView = Backbone.View.extend
    events:
      'keyup #url': 'update'

    urlPattern: /^https?:\/\/www.youtube\.com\//

    initialize: (options) ->
      this._handler = _.debounce(_.bind(this.handler, this), 700)

    handler: (url, callback) ->
      if this.urlPattern.test(url)
        match = /v=([a-zA-Z0-9_-]{11})/.exec(url)
        if match
          callback("{{Youtube:#{match[1]}}}")
          return
      callback()

    render: ->
      text_field =  _.template("<label for='<%= field_id %>'><%= label %></label>
              <input id='<%= field_id %>' type='text'>")
      this.$el.html(text_field
        field_id: 'url'
        label: 'Youtube URL'
      )

    update: (e) ->
      this._handler $(e.target).val(), (tag) ->
        if (tag)
          $('#tag-result').text(tag)

  window.YoutubeView = YoutubeView
