$ ->
  (->
    $(this).each ->
      [__, name, i] = $(this).attr('id').match(/^(.*)_(\d)$/)
      $(this).chained("##{name}_#{i - 1}") if i > 0
    ).call $('select.taxonomy')
