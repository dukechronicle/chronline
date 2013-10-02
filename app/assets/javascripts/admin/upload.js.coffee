#= require blueimp-tmpl/js/tmpl
#= require blueimp-load-image/js/load-image.min
#= require blueimp-canvas-to-blob/js/canvas-to-blob.min
#= require jquery-file-upload/js/jquery.iframe-transport
#= require jquery-file-upload/js/jquery.fileupload
#= require jquery-file-upload/js/jquery.fileupload-process
#= require jquery-file-upload/js/jquery.fileupload-image
#= require jquery-file-upload/js/jquery.fileupload-audio
#= require jquery-file-upload/js/jquery.fileupload-video
#= require jquery-file-upload/js/jquery.fileupload-validate
#= require jquery-file-upload/js/jquery.fileupload-ui

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
