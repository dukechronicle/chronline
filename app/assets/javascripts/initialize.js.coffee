window.initialize = do ->
  initializers = []

  $ ->
    for [selector, action] in initializers
      if not selector? or $(selector).length > 0
        try
          action.call $(selector)
        catch err
          console.error(err)

  (selector, action) ->
    if not action?
      selector = undefined
      action = selector
    initializers.push [selector, action]
