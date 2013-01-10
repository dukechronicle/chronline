getLayoutData = '{"a": 1}'

initialize 'form#page-settings', ->
  $(this).submit (e) ->
    try
      $(this).find('#page_layout_data').val(getLayoutData)
    catch err
      e.preventDefault()
