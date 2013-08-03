initialize '.input-enabler', ->
  $(this).change ->
    target = $(this).siblings('input, select')
    if $(this).is(':checked')
      $(target).removeAttr('disabled')
    else
      $(target).attr('disabled', true)
