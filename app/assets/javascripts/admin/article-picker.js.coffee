recentArticles = (callback) ->
  $.get(fullUrl('api', '/articles'), callback)

articleSearch = (query, callback) ->
  data =
    query: query
    sort: 'date'
  $.get(fullUrl('api', '/search'), data, callback)

# Can't use initialize because article-picker fields may be added dynamically
$ ->
  $('body').on 'focus', '.article-picker', ->
    $(this).typeahead
      minLength: 0
      source: (query, callback) ->
        queryCallback = (articles) ->
          callback(article.id + ' - ' + article.title for article in articles)
        if query.length > 2
          articleSearch(query, queryCallback)
        else
          recentArticles(queryCallback)
