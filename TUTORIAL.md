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
###The video

[![sipgate.io with Meteor](http://img.youtube.com/vi/ML8YFLuNNW0/0.jpg)](https://www.youtube.com/watch?v=ML8YFLuNNW0)


###Go
**1)** create a new meteor project

```bash
meteor create sipgateiotest
cd sipgateiotest
```

**2)** add the sipgate:io package

```bash
meteor add sipgate:io
```

**3)** create lib/collections.js to setup the collection on the server and client

```js
Calls = new Meteor.Collection("calls");
```

**4)** create server/sipgateio.js to insert calls into "Calls" collection

```js
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

```js
if (Meteor.isClient) {
  Template.phoneCalls.helpers({
    phoneCalls: function () {
      return Calls.find({}, {sort: {startDate: -1}});
    },
    from: function() {
      return this.from.replace(/^49/, "0");
    },
    to: function() {
      return this.from.replace(/^49/, "0");
    },
    startDate: function() {
      return this.startDate.toLocaleString();
    }
  });
}
```

**6)** change the full content of sipgateiotest.html to

```html
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
      <li>
        <span class="date">{{startDate}}</span>
        <span class="label">{{direction}}</span>
        <strong>{{from}}</strong> &rarr; <strong>{{to}}</strong>
      </li>
    {{/each}}
  </ul>
</template>
```

**7)** run meteor from the command line

```bash
    meteor
```

**8)** Ok. Looks kind of messy... As a bonus we make it look nice:

```bash
    curl -L -o nice.css "http://git.io/vUzgO"
```
