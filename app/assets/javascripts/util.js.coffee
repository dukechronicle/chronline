window.fullUrl = (subdomain, path) ->
  host = window.location.host.replace(/^\w+\./, subdomain + '.')
  '//' + host + path
