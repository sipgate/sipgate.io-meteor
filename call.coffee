class Call
  constructor: (data) ->
    @from = data.from
    @to = data.to
    @_id = data._id || data.callId
    @direction = data.direction
    @startDate = new Date()
    @active = true
    @user = this.userId

  hangup: ->
    @active = false
    @endDate = new Date()
