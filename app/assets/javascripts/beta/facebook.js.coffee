#= require beta/templates/social-share
#= require jquery.cookie/jquery.cookie

initialize '#facebook-social-share', ->
  $('#fb-root').on 'fbinit', =>
    (new SocialShare(el: this[0])).render()

SocialShare = Backbone.View.extend
  template: JST['beta/templates/social-share']

  events:
    'click .activity-toggle': 'toggleActivity'
    'click .toggle': 'toggleEnabled'
    'click .login': 'login'
    'click .delete': 'removeRead'

  initialize: ->
    @model = new Backbone.Model(
      enabled: not $.cookie('disable-sharing')
      showActivity: false
      article: location.href
    )
    FB.Event.subscribe(
      'auth.authResponseChange', this.checkPermissions.bind(this))
    this.listenTo(@model, 'change', @render)

  login: (e) ->
    e.preventDefault()
    FB.login(
      (response) ->
        console.error(response.error) if response.error?
      , scope: 'user_actions.news,publish_actions'
    )

  toggleEnabled: (e) ->
    e.preventDefault()
    if @model.get('enabled')
      $.cookie('disable-sharing', true, expires: 365 * 50, path: '/')
      @model.set('enabled', false)
    else
      $.removeCookie('disable-sharing', path: '/')
      @model.set('enabled', true)
      this.delayedReadArticle()

  toggleActivity: (e) ->
    e.preventDefault()
    attrs = { showActivity: not @model.get('showActivity') }
    unless @model.has('actions')
      attrs['actions'] = []
      this.fetchRecentActivity()
    @model.set(attrs)

  removeRead: (e) ->
    e.preventDefault()
    $target = $(e.target)
    $target.closest('tr').remove()
    FB.api $target.attr('data-id'), 'delete', (response) ->
      console.error(response.error) if response.error?

  delayedReadArticle: ->
    setTimeout(this.readArticle.bind(this), 20000)

  fetchRecentActivity: ->
    FB.api '/me/news.reads', (response) =>
      if response? and not response.error?
        @model.set(actions: response.data[0...10])

  readArticle: ->
    if @model.get('enabled')
      FB.api(
        '/me/news.reads',
        'post',
        article: @model.get('article'),
        (response) ->
          console.error(response.error) if response.error?
      )

  checkPermissions: (response) ->
    if response.status == 'connected'
      token = response.authResponse.accessToken
      FB.api '/me/permissions', (response) =>
        if response? and not response.error?
          permissions = response.data[0]
          if permissions['user_actions.news']? and permissions['publish_actions']?
            @model.set(token: token)
            this.delayedReadArticle()
          else
            @model.set('token', null)
    else
      @model.set('token', null)

  render: ->
    actions = (@model.get('actions') if @model.get('showActivity'))
    @$el.html(
      @template(
        authToken: @model.get('token')
        enabled: @model.get('enabled')
        actions: actions
      )
    )
    this
