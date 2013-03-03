fetchRecent = (callback) ->
  $.get(fullUrl('api', '/articles'), callback)

articleSearch = (query, callback) ->
  data =
    query: query
    sort: 'created_at'
  $.get(fullUrl('api', '/search'), data, callback)

# Can't use initialize because article-picker fields may be added dynamically
$ ->
  $('body').on 'focus', '.article-picker', ->
    $(this).typeahead
      minLength: 0
      items: 25
      source: do ->
        recentArticles = null
        (query, callback) ->
          results = (articles) ->
            (article.id + ' - ' + article.title for article in articles)
          if query.length > 3
            articleSearch query, (articles) ->
              if articles.length > 0
                callback(results(articles))
              else
                callback(recentArticles)
          else if not recentArticles?
            fetchRecent (articles) ->
              recentArticles = results(articles)
              callback(recentArticles)
          else
            callback(recentArticles)
          null  # can't return result of callback()
    $(this).keyup()  # trigger typeahead
