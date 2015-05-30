class SipgateResponseActionDial extends SipgateResponseAction
  tag: "Dial"
  options: []
##TODO: make anonymous="true" option available
  constructor: (number, callerId) ->
    @number = number
    @callerId = callerId

  xml: ->
    response = "<Dial"
    if @callerId
      response += " callerId=\""+@callerId+="\""
    response += "><Number>"+@number+"</Number></Dial>"
