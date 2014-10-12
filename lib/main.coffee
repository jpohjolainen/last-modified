LastModified = require './last-modified'

module.exports =
  configDefaults:
    rowsToRead: 20
    timeFormat: '%d.%m.%Y %H:%M:%S'

  events: []

  activate: ->
    atom.workspaceView.command "last-modified:toggle", => @toggle()
    @create()

  toggle: ->
    if @events.length > 0
      e.dispose() for e in @events
      @events = []
    else
      @create()

  create: ->
    atom.workspace.observeTextEditors (editor) =>
      lm = new LastModified(editor)
      @events.push lm.saveEvent 
