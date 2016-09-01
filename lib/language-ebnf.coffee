

{Emitter, CompositeDisposable, Task, Range} = require 'atom'

provider =
  providerName: 'language-xml-ebnf'
  wordRegExp: /[a-z_]+/ig
  getSuggestionForWord: (editor, text, range) ->
    return unless /[a-z_]+/ig.test(text)
    scopes = editor.scopeDescriptorForBufferPosition(range).getScopesArray()
    return if 'source.xml-ebnf' in not scopes
    # console.log "text: #{text}, range: #{range}"
    regex = ///\b#{text}(?=\s*::=)///ig
    matchRange = undefined
    editor.scan regex, (object) ->
      console.log "#{object.matchText} in #{object.range}"
      if object.matchText == text
        console.log "Hit!"
        matchRange = object.range
        object.stop()
    console.log "matchRange: #{matchRange}"
    return unless matchRange?
    return {
      range: range
      callback: ->
        console.log "callback! #{text}"
        editor.scrollToBufferPosition matchRange.start
        layer = editor.getDefaultMarkerLayer()
        marker = layer.markBufferRange matchRange,
          invalidate: 'never'
          persistent: false
        decoration = editor.decorateMarker marker,
          type: 'highlight'
          class: 'sample-flash'
        #decoration.setProperties 'data-content': text
        setTimeout -> 
          decoration.getMarker().destroy()
          editor.setSelectedBufferRange matchRange
        , 500
    }

module.exports =
  activate: ->
    console.log "activate!"
  
  getProvider: -> provider

