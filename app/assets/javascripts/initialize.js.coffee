initializers = []

$ ->
  for [selector, action] in initializers
    if not selector? or $(selector).length > 0
#      try
        action.call $(selector)
#      catch err
#        console.error(err)

window.initialize = (selector, action) ->
  if not action?
    action = selector
    selector = undefined
  initializers.push [selector, action]
