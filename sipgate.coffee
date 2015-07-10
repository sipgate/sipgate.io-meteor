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

        userEvents = self._events()

        if userEvents.answer
          self.response.setAnswerUrl(url+"io/answer/"+this.params.userId)

        if userEvents.hangup
          self.response.setHangupUrl(url+"io/hangup/"+this.params.userId)

        self._onEvent 'newCall', currentCall
        response = self.response.generateResponseXml()

        this.setContentType 'application/xml'
        response+"\n"

      "io/answer/:userId": post: (data) ->
        self.userId = self.params.userId
        callData = Sipgate.parsePost data
        call = new Call(self._Calls.findOne _id:callData.callId)
        call.answer()
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
        self._Calls.remove _id:call._id
        response = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Response><!--empty request--></Response>"""
        this.setContentType 'application/xml'
        response

  _onEvent: (eventType, call) ->
    for callback in @_callEvents[eventType]
      callback call

  _events: ->
    @_callEvents

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
