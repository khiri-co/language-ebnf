
{Emitter, CompositeDisposable, Task, Range} = require 'atom'

provider =
  providerName: 'language-xml-ebnf'
  wordRegExp: /[a-z_]+(?!\s*::=)/ig
  getSuggestionForWord: (editor, text, range) ->
    return unless /[a-z_]+/ig.test(text)
    scopes = editor.scopeDescriptorForBufferPosition(range).getScopesArray()
    return if 'source.xml-ebnf' in not scopes
    #console.log "text: #{text}, range: #{range}"
    regex = ///\b#{text}(?=\s*::=)///ig
    matchRange = undefined
    editor.scan regex, (object) ->
      console.log "#{object.matchText} in #{object.range}"
      if object.matchText == text
        console.log "Hit!"
        matchRange = object.range
        object.stop()
    #console.log "matchRange: #{matchRange}"
    return unless matchRange?
    
    #element = document.createElement('span')
    #element.textContent = text
    
    return {
      range: range
      callback: ->
        #console.log "callback! #{text}"
        editor.scrollToBufferPosition matchRange.start, {center: true}
        
        layer = editor.getDefaultMarkerLayer()
        marker = layer.markBufferRange matchRange,
          invalidate: 'never'
          persistent: false
        decoration = editor.decorateMarker marker,
          type: 'highlight'
          class: 'sample-flash'
        setTimeout -> 
          decoration.getMarker().destroy()
          editor.setSelectedBufferRange matchRange
        , 300
    }

module.exports =
  
  activate: ->
    #console.log "activate!"
    
    #@subscriptions = new CompositeDisposable
    #@subscriptions.add atom.styles.observeStyleElements (styleElement) ->
    #  console.log "styleElement.sourcePath: #{styleElement.sourcePath}"
    #  console.log "styleElement.context: #{styleElement.context}"

  getProvider: -> provider
