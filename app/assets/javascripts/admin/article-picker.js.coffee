# Can't use initialize because article-picker fields may be added dynamically
$ ->
  $('body').on 'focus', '.article-picker', ->
    $(this).typeahead
      minLength: 2
      source: (query, callback) ->
        data =
          query: query
          sort: 'date'
        $.get fullUrl('api', '/search'), data, (articles) ->
          callback(article.id + ' - ' + article.title for article in articles)
