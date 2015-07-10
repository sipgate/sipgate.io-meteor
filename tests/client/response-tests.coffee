Tinytest.add 'response - should return basic response XML when on params set', (test) ->
  response = new SipgateResponse()
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response />"""

Tinytest.add 'response - should return basic response XML with onAnswer param only', (test) ->
  response = new SipgateResponse()
  response.setAnswerUrl("http://no.url")
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onAnswer="http://no.url" />"""

Tinytest.add 'response - should return basic response XML with onHangup param only', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onHangup="http://no.url" />"""

Tinytest.add 'response - should return basic response XML with callback url, without actions', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAnswerUrl("http://no.url")
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onAnswer="http://no.url" onHangup="http://no.url" />"""

Tinytest.add 'response - should queue multiple actions', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAnswerUrl("http://no.url")
  response.setAction new SipgateResponseActionPlay("-")
  response.setAction new SipgateResponseActionHangup()
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onAnswer="http://no.url" onHangup="http://no.url"><Play><Url>-</Url></Play><Hangup /></Response>"""

Tinytest.add 'response - hangup - should appear in response', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAction new SipgateResponseActionHangup()
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onHangup="http://no.url"><Hangup /></Response>"""

Tinytest.add 'response - reject - should pass no option when none given', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAction new SipgateResponseActionReject()
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onHangup="http://no.url"><Reject /></Response>"""

Tinytest.add 'response - reject - should pass busy reason when given', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAction new SipgateResponseActionReject("busy")
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onHangup="http://no.url"><Reject reason="busy" /></Response>"""

Tinytest.add 'response - reject - should pass rejected reason when given', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAction new SipgateResponseActionReject("rejected")
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onHangup="http://no.url"><Reject reason="rejected" /></Response>"""

Tinytest.add 'response - play - should pass play URL', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAction new SipgateResponseActionPlay("http://test.de")
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onHangup="http://no.url"><Play><Url>http://test.de</Url></Play></Response>"""

Tinytest.add 'response - dial - should pass Phone Number to dial', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAction new SipgateResponseActionDial("492111234567")
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onHangup="http://no.url"><Dial><Number>492111234567</Number></Dial></Response>"""

Tinytest.add 'response - dial - should pass caller ID when given', (test) ->
  response = new SipgateResponse()
  response.setHangupUrl("http://no.url")
  response.setAction new SipgateResponseActionDial("492111234567", "492117654321")
  test.equal response.generateResponseXml(), """
  <?xml version="1.0" encoding="UTF-8"?>
  <Response onHangup="http://no.url"><Dial callerId="492117654321"><Number>492111234567</Number></Dial></Response>"""
