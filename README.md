#sipgate.io-meteor [![Build Status](https://travis-ci.org/sipgate/sipgate.io-meteor.svg?branch=master)](https://travis-ci.org/sipgate/sipgate.io-meteor)

Handle phone calls from meteor using [sipgate.io](https://github.com/sipgate/sipgate.io).
Check out the tutorial in our [gitbook](http://book.sipgate.io/content/meteor-js.html) on how to create a simple project.

## Installation

```bash
meteor add sipgate:io
```

## Sample

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

## Setup
Set up ***http://yourdomain.com***/io/call/***userid*** for incoming and outgoing calls in the sipgate.io settings of your sipgate team, sipgate basic or simquadrat account. If you are not using the *Meteor accounts package*, you can set a placeholder like 1 as userid.

## Tests
To run the tests execute `meteor test-packages ./` on the command line
