Handle phone calls from meteor using [sipgate.io](https://github.com/sipgate/sipgate.io)

##Installation
    meteor add sipgate:io


##Sample
    sipgate = new Sipgate()
    sipgate.events
      newCall: (call) ->
        Calls.insert call
      hangup: (call) ->
        Calls.update call._id, $set:call

##Usage
    set up http://yourdomain.com/io/call/userid 
