# Write your tests here!
# Here is an example.

Tinytest.add 'io - parsePost should assign post data to Object', (test) ->
  tempData = {}
  parsed = Sipgate.parsePost("a=b&c=d")

  test.equal parsed.c, "d"
