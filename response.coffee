class SipgateResponse
  _actions: []
  constructor: (answerUrl = null, hangupUrl = null)->
    @_actions = []
    @_answerUrl = answerUrl
    @_hangupUrl = hangupUrl

  xml: ->
    responseXml = ""
    responseXml += """<?xml version="1.0" encoding="UTF-8"?>\n"""
    responseXml += "<Response"

    if @_answerUrl
      responseXml += """ onAnswer=\"#{@_answerUrl}\""""

    if @_hangupUrl
      responseXml += """ onHangup=\"#{@_hangupUrl}\""""

    if @._actions.length > 0
      responseXml += ">"
    else
      responseXml += " />"

    for action in this._actions
      responseXml += action.xml()

    if @._actions.length > 0
      responseXml += '</Response>'

    responseXml

  action: (action) ->
    this._actions.push action
