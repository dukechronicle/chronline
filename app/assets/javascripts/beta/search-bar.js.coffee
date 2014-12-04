initialize '.search-section', ->
  $searchForm = $(this).find('.search-form')
  $searchInput = $searchForm.find('input')
  $searchPlaceholder = $(this).find('.search-placeholder')
  $searchPlaceholder.click ->
    $(this).hide()
    $searchForm.show()
    $searchInput.focus()

  $searchInput.blur ->
    $searchForm.hide()
    $searchPlaceholder.show()
