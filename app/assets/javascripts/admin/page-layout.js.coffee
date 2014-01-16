#= require react/react
#= require json-form/json-form

# ondeSession = null

# getLayoutData = ->
#   data = ondeSession.getData()
#   throw new Error(data.errorData) if data.errorCount > 0
#   JSON.stringify(data.data)

# loadTemplate = ->
#   $('form#layout-data .onde-panel').hide()
#   schema = $('#page_layout_template').children('option:selected').data('schema')
#   if schema
#     $('form#layout-data .onde-panel').show()
#     embedded = $('form#layout-data').data('embedded')
#     dataString = $('#page_layout_data').val()
#     data = JSON.parse(dataString) if dataString
#     ondeSession.render(schema, data, collapsedCollapsibles: true, embedded: embedded)

loadTemplate = ->
  schema = $('#page_layout_schema').children('option:selected').data('schema')
  if schema
    dataString = $('#page_layout_data').val()
    data = JSON.parse(dataString) if dataString
    form = document.querySelector('form#layout-data')
    React.unmountComponentAtNode(form)
    React.renderComponent(JsonForm(schema: schema, data: data), form)

initialize 'form#page-settings', ->
  $(this).find('#page_layout_schema').change ->
    loadTemplate()
  loadTemplate()

  # $(this).submit (e) ->
  #   try
  #     $(this).find('#page_layout_data').val(getLayoutData())
  #   catch err
  #     e.preventDefault()
  #     console.error(err)
