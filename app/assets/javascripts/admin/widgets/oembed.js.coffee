initialize '#widget-editor', ->
  OembedView = Backbone.View.extend
    events:
      'keyup #url': 'update'

    initialize: (options) ->
      this._handler = _.debounce(_.bind(this.handler, this), 700)

    handler: (url, callback) ->
      $.getJSON('widgets/match_url', {url: url})
        .done((data) ->
          if (data.tag)
            console.log("valid '#{data.tag}'")
            callback(data.tag)
          else
            console.log('invalid')
            callback("Invalid url!")
        )

    render: ->
      text_field = _.template("<label for='<%= field_id %>'><%= label %></label>
              <input id='<%= field_id %>' type='text'>")
      this.$el.html(text_field
        field_id: 'url'
        label: 'URL'
      )

    update: (e) ->
      this._handler $(e.target).val(), (tag) ->
        if (tag)
          $('#tag-result').text(tag)

  window.OembedView = OembedView
