initialize '#widget-editor', ->
  SoundcloudView = Backbone.View.extend
    events:
      'keyup #url': 'update'

    urlPattern: /^https?:\/\/soundcloud\.com\//

    initialize: (options) ->
      this._handler = _.debounce(_.bind(this.handler, this), 700)

    handler: (url, callback) ->
      if this.urlPattern.test(url)
        $.getJSON "http://soundcloud.com/oembed?url=#{url}", (data) ->
          id = /tracks%2F(\d+)&/.exec(data.html)[1]
          callback("{{Soundcloud:#{id}}}")
      else
        callback("Invalid url!")

    render: ->
      text_field = _.template("<label for='<%= field_id %>'><%= label %></label>
              <input id='<%= field_id %>' type='text'>")
      this.$el.html(text_field
        field_id: 'url'
        label: 'Soundcloud URL'
      )

    update: (e) ->
      this._handler $(e.target).val(), (tag) ->
        if (tag)
          $('#tag-result').text(tag)

  window.SoundcloudView = SoundcloudView
