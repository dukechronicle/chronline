#= require react/react
#= require json-form/json-form

class JsonArticle extends JsonNumber
  constructor: (schema, data, root, fragments) ->
    this.initialize(schema, data, root, fragments)

  fetchArticle: (callback) ->
    if this.value()
      # TODO: batch fetch these
      $.get(fullUrl('api', "/articles/#{this.value()}"), callback)

  fetchArticles: do ->
    recentArticles = null
    (query, callback) ->
      results = (articles) ->
        (article.id + ' - ' + article.title for article in articles)
      callbackRecent = =>
        if recentArticles?
          callback(recentArticles)
        else
          this._fetchRecent (articles) ->
            recentArticles = results(articles)
            callback(recentArticles)

      if query.length > 3
        this._articleSearch query, (articles) ->
          if articles.length > 0
            callback(results(articles))
          else
            callbackRecent()
      else
        callbackRecent()
      null  # can't return result of callback()

  _articleSearch: (query, callback) ->
    data =
      query: query
      sort: 'date'
    $.get(fullUrl('api', '/search'), data, callback)

  _fetchRecent: (callback) ->
    $.get(fullUrl('api', '/articles'), callback)

JsonArticle.validatesSchema = (schema) ->
  schema.display == 'article-picker'

JsonValidator.validators.push(JsonArticle)


JsonArticle.prototype.view = React.createClass
  getInitialState: -> {}

  componentWillMount: ->
    @props.validator.fetchArticle (article) =>
      this.setState(articleTitle: "#{article.id} - #{article.title}")

  componentDidMount: (node) ->
    $(node).children('input').typeahead
      minLength: 0
      items: 25
      updater: (item) =>
        this.handleSelect(item)
        item
      source: @props.validator.fetchArticles.bind(@props.validator)

  handleSelect: (rawValue) ->
    value = parseInt(rawValue);
    value = undefined if isNaN(value)
    @props.validator.setData(value)
    @props.onChange(@props.validator)

  handleChange: (e) ->
    this.setState(articleTitle: e.target.value)

  render: ->
    React.DOM.span {}, null, [
      React.DOM.input(
        className: 'input-xlarge article-picker'
        onChange: this.handleSelect
        onFocus: (e) -> $(e.target).keyup()  # Trigger typeahead
        type: 'text'
        value: @state.articleTitle
      )
    ]
