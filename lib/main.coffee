LastModified = require './last-modified'

module.exports =
  configDefaults:
    rowsToRead: 20
    timeFormat: '%d.%m.%Y %H:%M:%S'

  handlers: []

  activate: ->
    atom.workspaceView.command "last-modified:toggle", => @toggle()
    @create()

  toggle: ->
    if @handlers.length > 0
      handle.dispose() for handle in @handlers
      @handlers = []
    else
      @create()

  create: ->
    atom.workspace.observeTextEditors (editor) =>
      @editor = editor
      lm = new LastModified(editor)
      @handlers.push lm.saveHandler
