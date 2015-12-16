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
        proto = this.requestHeaders["x-forwarded-proto"]
        if proto
          protocols = proto.split ","
          protocol = protocols[0]
          url = protocol+"://"+domain+"/"
        else
          url = Meteor.absoluteUrl()

        callData = Sipgate.parsePost data
        callData.userId = this.params.userId
        currentCall = new Call(callData)
        self._Calls.insert currentCall

        actions = self._onEvent 'newCall', currentCall

        userEvents = self._events()

        if userEvents.answer
          self.response.setAnswerUrl(url+"io/answer/"+this.params.userId)

        if userEvents.hangup
          self.response.setHangupUrl(url+"io/hangup/"+this.params.userId)

        if actions
          for action in actions
            if action instanceof SipgateResponseActionGather
              action.setDataUrl(url+"io/dtmf/"+this.params.userId)
            self.response.setActions(actions)

        response = self.response.generateResponseXml()

        this.setContentType 'application/xml'
        response+"\n"

      "io/answer/:userId": post: (data) ->
        callData = Sipgate.parsePost data
        callData.userId = this.params.userId
        call = new Call(self._Calls.findOne _id:callData.callId)
        call.answer(callData)
        self._Calls.update _id:call._id, call
        self._onEvent 'answer', call
        response = """
        <?xml version="1.0" encoding="UTF-8"?>
        <Response><!--empty request--></Response>"""
        this.setContentType 'application/xml'
        response

      "io/hangup/:userId": post: (data) ->
        callData = Sipgate.parsePost data
        callData.userId = this.params.userId
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

      "io/dtmf/:userId": post: (data) ->
        domain = this.requestHeaders.host
        proto = this.requestHeaders["x-forwarded-proto"]
        if proto
          protocols = proto.split ","
          protocol = protocols[0]
          url = protocol+"://"+domain+"/"
        else
          url = Meteor.absoluteUrl()

        callData = Sipgate.parsePost data
        callData.userId = this.params.userId
        call = new Call(self._Calls.findOne _id:callData.callId)
        call.dtmf(callData.dtmf)
        self._Calls.update _id:call._id, call

        actions = self._onEvent 'dtmf', call

        userEvents = self._events()

        if userEvents.answer
          self.response.setAnswerUrl(url+"io/answer/"+this.params.userId)

        if userEvents.hangup
          self.response.setHangupUrl(url+"io/hangup/"+this.params.userId)

        if actions
          for action in actions
            if action instanceof SipgateResponseActionGather
              action.setDataUrl(url+"io/dtmf/"+this.params.userId)
          self.response.setActions(actions)

        response = self.response.generateResponseXml()

        this.setContentType 'application/xml'
        response+"\n"

  _onEvent: (eventType, call) ->
    value = null
    for callback in @_callEvents[eventType]
      currentValue = callback call
      if currentValue
        value = currentValue
    value

  _events: ->
    @_callEvents

  @parsePost: (input="") ->
    result = {}
    parts = input.toString().split '&'
    parts.forEach (part) ->
      [key, value] = part.split '='

      key = decodeURIComponent(key)
      value = decodeURIComponent(value.replace(/\+/g," ")) #decodeURIComponent doesn't replace the +-encoded spaces :(

      # There can be several user-params when calling a group
      if (key == 'user[]')
        if (!result['user']?)
          result['user'] = []
        result['user'].push(value)
      else
        result[key] = value
    result

  events: (events) ->
    for key, value of events
      @_callEvents[key] ?= []
      @_callEvents[key].push value
