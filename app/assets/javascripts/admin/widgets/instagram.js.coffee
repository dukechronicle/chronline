initialize '#widget-editor', ->
  InstagramView = Backbone.View.extend
    events:
      'keyup #url': 'update'

    urlPattern: /^https?:\/\/instagram\.com\//

    initialize: (options) ->
      this._handler = _.debounce(_.bind(this.handler, this), 700)

    handler: (url, callback) ->
      if this.urlPattern.test(url)
        callback("{{Instagram:#{url}}}")
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
