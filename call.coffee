class Call
  constructor: (data) ->
    @from = data.from
    @to = data.to
    @callid = data._id || data.callId
    @direction = data.direction
    @date = data.startDate || ''
    @user = data.userId
    @sipgateUser = data.user

  answer: (data) ->
    @date = ''
    @active = true
    @sipgateUser = data.user

  hangup: (cause)->
    @active = false
    @date = ''
    @cause = cause
