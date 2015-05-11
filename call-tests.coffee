# Write your tests here!
# Here is an example.

Tinytest.add 'call - callId should be mapped to _id', (test) ->
  myCall = new Call(
    from: ''
    to: ''
    callId: '1'
    direction: ''
  )
  test.equal myCall._id, "1"

Tinytest.add 'call - new call should be active', (test) ->
  myCall = new Call(
    from: ''
    to: ''
    callId: '1'
    direction: ''
  )
  test.isTrue myCall.active

Tinytest.add 'call - hanging up should change active to false', (test) ->
  myCall = new Call(
    from: ''
    to: ''
    callId: '1'
    direction: ''
  )
  myCall.hangup()
  test.isFalse myCall.active
