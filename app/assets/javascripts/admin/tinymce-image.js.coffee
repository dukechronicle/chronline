tinymce.PluginManager.add 'image', (editor) ->
  openMenu = ->
    imageSelector.open (image) ->
      tag = "{{Image:#{image.id}}}"
      tinyMCE.activeEditor.execCommand('mceInsertContent', false, tag)

  editor.addButton('image',
    icon: 'image',
    tooltip: 'Insert image',
    onclick: openMenu,
    stateSelector: 'img:not([data-mce-object])'
  )

  editor.addMenuItem('image',
    icon: 'image',
    text: 'Insert image',
    onclick: openMenu,
    context: 'insert',
    prependToContext: true
  )
