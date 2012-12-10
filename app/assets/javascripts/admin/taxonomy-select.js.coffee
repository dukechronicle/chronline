$ ->
  updateTaxonomy = ($taxonomy, $field) ->
    taxonomy = _.compact($taxonomy.map(-> $(this).val()).get())
    $field.val('/' + (s.toLowerCase() + '/' for s in taxonomy).join(''))

  (->
    $selects = $(this)
    $taxonomyField = $(this).siblings('input.taxonomy')
    $(this).change -> updateTaxonomy($selects, $taxonomyField)
    $(this).each ->
      i = $(this).attr('id').match(/taxonomy_(\d)/)[1]
      $(this).chained("#taxonomy_#{i - 1}") if i > 0
    ).call $('select.taxonomy')
