strftime = require('strftime')

module.exports =
class LastModified
  constructor: (editor) ->
    @editor = editor

    buffer = @editor.getBuffer()

    @saveHandler = buffer.onWillSave =>
      @updateLastModified()

  updateLastModified: ->
    return unless @editor.isModified()

    rowsToRead = atom.config.get 'last-modified.rowsToRead'
    rowsRange = [[0,0], [rowsToRead, 0]]
    @editor.scanInBufferRange /Last Modified:/, rowsRange, (match) =>
      scopes = @editor.scopesForBufferPosition match.range.start
      if scopes[1]?.match /^comment/
        @replaceDate match.range.end

  replaceDate: (pos)->
    return unless pos

    start = pos
    end = pos.toArray()
    end[1] = 'Infinity'
    now = new Date()
    format = atom.config.get 'last-modified.timeFormat'

    try
      @editor.setTextInBufferRange [start, end], ' ' + strftime(format, now)
    catch err
      console.error err.message
