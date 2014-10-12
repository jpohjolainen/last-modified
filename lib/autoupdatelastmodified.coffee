module.exports =
class AutoUpdateLastModified
  update: (editor) ->
    console.log 'updateLastModified'
    rowsToRead = atom.config.get('last-modified.rowsToRead')
    rowsRange = [[0,0], [rowsToRead, 0]]
    console.log rowsRange
    editor.scanInBufferRange /Last Modified: /, rowsRange, (match) ->
      scopes = editor.scopesForBufferPosition(match.range.start)
      console.log scopes
      if scopes[1]?.match(/comment/)
        @replaceDate(editor, match.range.end)

  replaceDate: (editor, position) ->
    start = position
    end = position
    now = new Date()
    console.log start, end, now
    
    editor.scanInBufferRange /(.*?)$/, [start, end], (match) ->
      match.replace(now.toString())
