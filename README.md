#sipgate.io-meteor [![Build Status](https://travis-ci.org/sipgate/sipgate.io-meteor.svg?branch=master)](https://travis-ci.org/sipgate/sipgate.io-meteor)

Handle phone calls from meteor using [sipgate.io](https://github.com/sipgate/sipgate.io)
check out the [tutorial](TUTORIAL.md) on how to create a simple project

##Installation
    meteor add sipgate:io


##Sample

### JavaScript
```js
sipgate = new Sipgate();
sipgate.events({
  newCall: function(call) {
    Calls.insert(call)
  },
  hangup: function (call) {
    Calls.update(call._id, {$set:call});
  }
});
```

### CoffeeScript
```coffee
sipgate = new Sipgate()
sipgate.events
  newCall: (call) ->
    Calls.insert call
  hangup: (call) ->
    Calls.update call._id, $set:call
```

##Setup
set up ***http://yourdomain.com***/io/call/***userid*** for incoming and outgoing calls in sipgate.io

##Tests
to run the tests execute `meteor test-packages ./` on the command line
