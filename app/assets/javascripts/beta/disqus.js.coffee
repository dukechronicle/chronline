loadDisqus = (path='embed.js') ->
  dsq = document.createElement('script')
  dsq.type = 'text/javascript'
  dsq.async = true
  dsq.src = "//#{disqus_shortname}.disqus.com/#{path}"
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq)

configureDisqus = (options) ->
  _.extend(window,
    disqus_developer: if options.production then 0 else 1
    disqus_shortname: options.shortname
    disqus_identifier: options.identifier
    disqus_url: options.url
    disqus_title: options.title.replace("'", "\\'")
    disqus_category_id: options.category_id
  )

initialize '#disqus_thread', ->
  configureDisqus $('#disqus_thread').data('disqus')
  loadDisqus('embed.js')
  loadDisqus('count.js')
