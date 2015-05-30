class SipgateResponse
  _actions: []
  constructor: (hangupUrl)->
    @_actions = []
    @_hangupUrl = hangupUrl

  xml: ->
    if this._actions.length == 0
      return """
      <?xml version="1.0" encoding="UTF-8"?>
      <Response onHangup="#{@_hangupUrl}" />"""

    responseXml = ""
    for action in this._actions
      responseXml+=action.xml()

    return """
    <?xml version="1.0" encoding="UTF-8"?>
    <Response onHangup="#{@_hangupUrl}">#{responseXml}</Response>"""

  action: (action) ->
    this._actions.push action
