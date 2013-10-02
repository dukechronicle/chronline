#= require jquery.chained.js

initialize 'select.taxonomy', ->
  $selects = $(this)
  $selects.each (i) ->
    $(this).chained($selects.eq(i - 1)) if i > 0
