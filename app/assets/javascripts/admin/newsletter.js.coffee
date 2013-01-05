initialize '.input-enabler', ->
  $(this).change ->
    target = '#' + $(this).data('target')
    if $(this).is(':checked')
      $(target).removeAttr('disabled')
    else
      $(target).attr('disabled', true)
