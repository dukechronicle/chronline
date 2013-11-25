initialize '#widget-editor', ->
  ImageView = Backbone.View.extend
    events:
      'click #choose': 'update'

    handler: (callback) ->
      imageSelector.open (image) ->
        callback(image.id)

    render: ->
      this.$el.html('<a href="#" id="choose">Choose Image</a>')

    update: (e) ->
      e.preventDefault()
      this.handler (id) ->
        $('#tag-result').text("{{Image:#{id}}}")

  window.ImageView = ImageView
