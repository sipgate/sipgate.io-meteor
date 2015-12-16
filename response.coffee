class SipgateResponse
  _actions: []
  _answerUrl: null
  _hangupUrl: null

  constructor: ->
    @_actions = []
    #@_answerUrl = answerUrl
    #@_hangupUrl = hangupUrl

  setAnswerUrl: (answerUrl) ->
    @_answerUrl = answerUrl

  setHangupUrl: (hangupUrl) ->
    @_hangupUrl = hangupUrl

  setActions: (actions) ->
    this._actions = actions

  generateResponseXml: ->
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


