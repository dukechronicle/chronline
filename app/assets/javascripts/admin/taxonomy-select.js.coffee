$ ->
  (->
    $selects = $(this)
    $selects.each (i) ->
      $(this).chained($selects.eq(i - 1)) if i > 0
    ).call $('select.taxonomy')
