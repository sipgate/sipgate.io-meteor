class SipgateResponseActionReject extends SipgateResponseAction
  tag: "Reject"
  options: []

  constructor: (rejectReason) ->
    if (rejectReason)
      @options = [ reason: rejectReason ]
