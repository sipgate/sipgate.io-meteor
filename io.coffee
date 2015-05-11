class Sipgate
  _calls: {}
  _callEvents: {}
  _Calls: new Meteor.Collection('_sipgateIoCalls')

  constructor: ->
    self = this
    HTTP.methods
      "io/call/:userId": post: (data) ->
        domain = this.requestHeaders.host
        protocol = this.requestHeaders["x-forwarded-proto"]
        url = protocol+"://"+domain+"/"
        this.userId = this.params.userId
        callData = Sipgate.parsePost data
        currentCall = new Call(callData)
        self._Calls.insert currentCall;
        self._onEvent 'newCall', currentCall
        response = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Response onHangup="#{url}io/hangup/#{this.params.userId}">
        </Response>"""
        this.setContentType 'application/xml'
        response

      "io/hangup/:userId": post: (data) ->
        this.userId = this.params.userId
        callData = Sipgate.parsePost data
        call = new Call(self._Calls.findOne _id:callData.callId)
        call.hangup()
        self._Calls.update _id:call._id, call
        self._onEvent 'hangup', call
        response = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Response><!--empty request--></Response>"""
        this.setContentType 'application/xml'
        response

  _onEvent: (eventType, call) ->
    for callback in @_callEvents[eventType]
      callback call

  @parsePost: (input="") ->
    result = {}
    parts = input.toString().split '&'
    parts.forEach (part) ->
      divided = part.split '='
      result[divided[0]] = divided[1]
    result

  events: (events) ->
    for key, value of events
      @_callEvents[key] ?= []
      @_callEvents[key].push value
