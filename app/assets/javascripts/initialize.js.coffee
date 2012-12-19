initializers = []

$ ->
  for [selector, action] in initializers
    if not selector? or $(selector).length > 0
      action.call $(selector)
#      try
#        action.call $(selector)
#      catch err
#        console.error(err)

window.initialize = (selector, action) ->
  if not action?
    selector = undefined
    action = selector
  initializers.push [selector, action]
