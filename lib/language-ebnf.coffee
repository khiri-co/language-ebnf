

{Emitter, CompositeDisposable, Task, Range} = require 'atom'

provider =
  providerName: 'xml-ebnf-hyperclick'
  wordRegExp: /[a-z_]+/ig
  getSuggestionForWord: (editor, text, range) ->
    scopeNames = editor.getRootScopeDescriptor().getScopesArray()
    return if 'source.xml-ebnf' in not scopeNames
    console.log "text: #{text}, range: #{range}"
    return {
      range: range
      callback: ->
        console.log 'callback'
    }

module.exports =
  getProvider: -> provider

