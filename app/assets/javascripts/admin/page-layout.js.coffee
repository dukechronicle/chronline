ondeSession = null

getLayoutData = ->
  data = ondeSession.getData()
  throw new Error(data.errorData) if data.errorCount > 0
  JSON.stringify(data.data)

loadTemplate = ->
  $('form#layout-data .onde-panel').hide()
  schema = $('#page_layout_template').children('option:selected').data('schema')
  if schema
    $('form#layout-data .onde-panel').show()
    embedded = $('form#layout-data').data('embedded')
    dataString = $('#page_layout_data').val()
    data = JSON.parse(dataString) if dataString
    ondeSession.render(schema, data, collapsedCollapsibles: true, embedded: embedded)

initialize 'form#page-settings', ->
  ondeSession = new onde.Onde($('form#layout-data'))

  $(this).find('#page_layout_template').change ->
    loadTemplate()
  loadTemplate()

  $(this).submit (e) ->
    try
      $(this).find('#page_layout_data').val(getLayoutData())
    catch err
      e.preventDefault()
      console.error(err)