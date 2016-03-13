{CompositeDisposable} = require 'atom'

module.exports = PasteTable =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'paste-table:paste-table': => @paste()

  deactivate: ->
    @subscriptions.dispose()

  paste: ->
    return unless editor = atom.workspace.getActiveTextEditor()
    tableText = atom.clipboard.read()
    tableRows = tableText.split(/\n/)
    tableHeader = tableRows.shift()
    output = ""
    output += "<table>\n\t<thead>\n\t\t<tr>"
    for column in tableHeader.split(/\t/)
      output += "\n\t\t\t<th>" + column + "</th>"
    output += "\n\t\t</tr>\n\t</thead>"
    output += "\n\t<tbody>"
    for row in tableRows
      output += "\n\t\t<tr>"
      for column in row.split(/\t/)
        output += "<td>" + column + "</td>"
      output += "</tr>"
    output += "\n\t</tbody>"
    output += "\n</table>"
    editor.insertText(output)
