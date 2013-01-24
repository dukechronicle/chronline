# Can't use initialize because author-picker fields may be added dynamically
$ ->
  $('body').on 'click', '.staff-picker', ->
    $(this).typeahead
    source: (query, callback) ->
      $.get fullUrl('api', '/staff'), {search: query}, (staff) ->
        callback((member.name for member in staff))

initialize 'form.staff-search', ->
  $(this).submit (e) ->
    e.preventDefault()
    slug = $(this).find('input').val().toLowerCase().replace(/\s/g, '-')
    window.location = "/staff/#{slug}/edit"
