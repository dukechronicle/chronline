#= require react/react
#= require json-form/json-form

loadTemplate = ->
  schema = $('#page_layout_schema').children('option:selected').data('schema')
  if schema
    dataString = $('#page_layout_data').val()
    data = JSON.parse(dataString) if dataString

    component = JsonForm(schema: schema, data: data)
    form = document.querySelector('form#layout-data')

    React.unmountComponentAtNode(form)
    React.renderComponent(component, form)
    component

initialize 'form#page-settings', ->
  $(this).find('#page_layout_schema').change =>
    $(this).find('#page_layout_data').val(null)
    @component = loadTemplate()
  @component = loadTemplate()

  $(this).submit (e) =>
    value = @component.value()
    if value != undefined
      $(this).find('#page_layout_data').val(JSON.stringify(value))
    else
      e.preventDefault()
      alert('Please fix errors with layout before submitting')
