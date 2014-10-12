strftime = require('strftime')

module.exports =
class LastModified
  constructor: (editor) ->
    @editor = editor

    buffer = @editor.getBuffer()

    @saveEvent = buffer.onWillSave =>
      @updateLastModified()

  updateLastModified: ->
    return if not @editor.isModified()

    console.log 'updateLastModified:', @editor.getBuffer().file.path
    rowsToRead = atom.config.get('last-modified.rowsToRead')
    rowsRange = [[0,0], [rowsToRead, 0]]
    @editor.scanInBufferRange /Last Modified:/, rowsRange, (match) =>
      scopes = @editor.scopesForBufferPosition(match.range.start)
      console.log scopes
      if scopes[1]?.match(/comment/)
        @replaceDate(match.range.end)

  replaceDate: (pos)->
    start = pos
    end = pos.toArray()
    end[1] = 'Infinity'
    now = new Date()
    format = atom.config.get('last-modified.timeFormat')
    @editor.setTextInBufferRange([start, end], ' ' + strftime(format, now))
