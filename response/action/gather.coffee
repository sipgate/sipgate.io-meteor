class SipgateResponseActionGather extends SipgateResponseAction
  tag: "Gather"
  options: []
  action: null
  maxDigits: null
  timeout: null
  onDataUrl: null

  constructor: (action, maxDigits, timeout) ->
    @action = action
    @maxDigits = maxDigits
    @timeout = timeout

  setDataUrl: (url) ->
    @onDataUrl = url

  xml: ->
    responseXml = "<Gather"

    if @onDataUrl
      responseXml += " onData=\"" + @onDataUrl + "\""

    if @maxDigits
      responseXml += " maxDigits=\"" + @maxDigits + "\""

    if @timeout
      responseXml += " timeout=\"" + @timeout + "\""


    responseXml += ">"

    if @action
      responseXml += @action.xml()

    responseXml += "</Gather>"

    responseXml
