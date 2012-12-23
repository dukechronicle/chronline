staffTypeahead = (type) ->
  ->
    $(this).typeahead
      source: (query, callback) ->
        data = {search: query}
        data.type = type if type?
        $.get fullUrl('api', '/staff'), data, (staff) ->
          callback((member.name for member in staff))

# Can't use initialize because author-picker fields may be added dynamically
$ ->
  $('body').on('click', '.staff-picker', staffTypeahead())
  $('body').on('click', '.author-picker', staffTypeahead('Author'))
  $('body').on('click', '.photographer-picker', staffTypeahead('Photographer'))
