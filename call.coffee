class Call
  constructor: (data) ->
    @from = data.from
    @to = data.to
    @_id = data._id || data.callId
    @direction = data.direction
    @startDate = data.startDate || new Date()
    @user = this.userId

  answer: ->
    @answerDate = new Date()
    @active = true

  hangup: (cause)->
    @active = false
    @endDate = new Date()
    @cause = cause
