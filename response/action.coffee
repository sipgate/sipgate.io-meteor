class SipgateResponseAction
  tag: ""
  options: []

  xml: ->
    tag = "<"+this.tag
    for option in this.options
      tag += " "+key+"=\""+value+"\"" for key, value of option

    tag += " />"
