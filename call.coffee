class Call
  constructor: (data) ->
    @from = data.from
    @to = data.to
    @_id = data._id || data.callId
    @direction = data.direction
    @startDate = data.startDate || new Date()
    @user = data.userId
    @sipgateUser = data.user

  answer: (data) ->
    @answerDate = new Date()
    @active = true
    @sipgateUser = data.user

  hangup: (cause) ->
    @active = false
    @endDate = new Date()
    @cause = cause

  dtmf: (dtmf) ->
    @dtmf = dtmf
