# Write your tests here!
# Here is an example.

class HTTP
  @definedMethods: {}
  requestHeaders:
    host: "none"
  @methods: (params) ->
    HTTP.definedMethods = params
    params


Tinytest.add 'io - parsePost should assign post data to Object', (test) ->
  tempData = {}
  parsed = Sipgate.parsePost("a=b&c=d")

  test.equal parsed.c, "d"

Tinytest.add 'io - instance should be created successfully', (test) ->
  io = new Sipgate
  test.instanceOf io, Sipgate

Tinytest.add 'io - call path post should be listened to', (test) ->
  io = new Sipgate
  test.instanceOf HTTP.definedMethods["io/call/:userId"].post, Function

Tinytest.add 'io - answer path post should be listened to', (test) ->
  io = new Sipgate()
  test.instanceOf HTTP.definedMethods['io/answer/:userId'].post, Function

Tinytest.add 'io - hangup path post should be listened to', (test) ->
  io = new Sipgate
  test.instanceOf HTTP.definedMethods["io/hangup/:userId"].post, Function
