##Tutorial

###Preparation

To handle calls from sipgate.io on your local machine you need a way to forward calls from the internet. You can use an SSH tunnel or port forwarding, but the easiest way seems to be using specialized software like [ngrok](https://ngrok.com/) or [ProxyLocal](http://proxylocal.com/).

####ngrok
    ngrok http 3000

####proxylocal
    proxylocal 3000

to setup your sipgate account enter the following URLs for incoming and outgoing calls

    [http://yourdomain.com]/io/call/1

Note: The 1 after call is just a placeholder we use because there is no user handling in our app

###Go
**1)** create a new meteor project

    meteor create sipgateiotest
    cd sipgateiotest

**2)** add the sipgate:io package

    meteor add sipgate:io

**3)** create lib/collections.js to setup the collection on the server and client

```JavaScript
Calls = new Meteor.Collection("calls");
```

**4)** create server/sipgateio.js to insert calls into "Calls" collection

```JavaScript
sipgate = new Sipgate();
sipgate.events({
  // insert new calls into collection
  newCall: function(call) {
    Calls.insert(call)
  },
  // update call data on hangup
  hangup: function (call) {
    Calls.update(call._id, {$set:call});
  }
});
```
**5)** change the full content of sipgateiotest.js to

```JavaScript
if (Meteor.isClient) {
  Template.phoneCalls.helpers({
    phoneCalls: function () {
      return Calls.find({});
    }
  });
}
```

**6)** change the full content of sipgateiotest.html to

```HTML
<head>
  <title>sipgateiotest</title>
</head>

<body>
  <h1>Welcome to sipgate.io!</h1>

  {{> phoneCalls}}
</body>

<template name="phoneCalls">
  <ul>
    {{#each phoneCalls}}
      <li>Direction: {{direction}} from: {{from}} to:{{to}}</li>
    {{/each}}
  </ul>
</template>
```

**7)** run meteor from the command line

    meteor
