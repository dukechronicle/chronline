#= require_tree ./widgets/

initialize '#widget-editor', ->
  WidgetRouter = Backbone.Router.extend
    el: $('#widget-editor')

    providers:
      'image': ImageView
      'poll': PollView
      'url': OembedView

    routes:
      ':provider': 'loadView'

    initialize: ->
      link_template = _.template(
        '<li><a href="#<%= name %>"><%= name %></a></li>')
      methods_sidebar = $('#methods')
      for k of this.providers
        methods_sidebar.append(link_template({name: k}))

    loadView: (provider) ->
      this.view and $(this.view.el).remove()
      this.view = new this.providers[provider]()
      this.el.html(this.view.el)
      this.view.render()

  AppView = Backbone.View.extend
    initialize: ->
      router = new WidgetRouter()
      Backbone.history.start()

  app = new AppView()
