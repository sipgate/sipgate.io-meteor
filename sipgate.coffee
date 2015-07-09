class Sipgate
  _calls: {}
  _callEvents: {}
  _Calls: new Meteor.Collection('_sipgateIoCalls')
  response: new SipgateResponse()

  constructor: ->
    self = this
    HTTP.methods
      "io/call/:userId": post: (data) ->
        domain = this.requestHeaders.host
        protocols = this.requestHeaders["x-forwarded-proto"].split ","
        protocol = protocols[0]
        url = protocol+"://"+domain+"/"
        this.userId = this.params.userId
        callData = Sipgate.parsePost data
        currentCall = new Call(callData)
        self._Calls.insert currentCall
        self.response = new SipgateResponse(url+"io/answer/"+this.params.userId, url+"io/hangup/"+this.params.userId)
        self._onEvent 'newCall', currentCall
        response = self.response.xml()

        this.setContentType 'application/xml'
        response+"\n"

      "io/answer/:userId": post: (data) ->
        this.userId = this.params.userId
        callData = Sipgate.parsePost data
        call = new Call(self._Calls.findOne _id:callData.callId)
        self._Calls.update _id:call._id, call
        self._onEvent 'answer', call
        response = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Response><!--empty request--></Response>"""
        this.setContentType 'application/xml'
        response

      "io/hangup/:userId": post: (data) ->
        this.userId = this.params.userId
        callData = Sipgate.parsePost data
        call = new Call(self._Calls.findOne _id:callData.callId)
        call.hangup(callData.cause)
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
