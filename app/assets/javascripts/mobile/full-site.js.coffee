initialize '#full-site', ->
  $(this).click (e) ->
    e.preventDefault()
    path = location.pathname + location.search
    path += if location.search then "&" else "?"
    path += 'force_full_site=true'
    location.href = fullUrl('www', path)
