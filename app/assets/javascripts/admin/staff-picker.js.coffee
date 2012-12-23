initialize '.staff-picker', ->
  $(this).typeahead
    source: (query, callback) ->
      $.get fullUrl('api', '/staff'), {search: query}, (staff) ->
        callback((member.name for member in staff))
