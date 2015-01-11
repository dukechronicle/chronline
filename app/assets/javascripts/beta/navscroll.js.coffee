#= require jquery.hoverscroll

initialize '.subnav', ->
  if $(this)[0].scrollWidth > $(this).width()
    $(this).hoverscroll
      vertical: false
      width: 518
      height: 36
      arrows: true
      arrowsOpacity: .6  # Max possible opacity of the arrows
      fixedArrows: false  # Fixed arrows on the sides of the list (disables arrowsOpacity)
      rtl:      false     # Print images from right to left
      debug:    false     # Debug output in the firebug console
