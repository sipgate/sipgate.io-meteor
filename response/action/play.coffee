class SipgateResponseActionPlay extends SipgateResponseAction
  tag: "Play"
  options: []

  constructor: (url) ->
    @url = url

  xml: ->
    "<Play><Url>"+@url+"</Url></Play>"
