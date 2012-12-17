$ ->
  $('#fileupload').fileupload()

  # Enable iframe cross-domain access via redirect option:
  $('#fileupload').fileupload(
    'option',
    'redirect',
    window.location.href.replace(
      /\/[^\/]*$/,
      '/cors/result.html?%s'
    )
  )
