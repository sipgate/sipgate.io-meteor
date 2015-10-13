Package.describe({
  name: 'sipgate:io',
  version: '0.0.15',
  // Brief, one-line summary of the package.
  summary: 'use sipgate.io in meteor',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/sipgate/sipgate.io-meteor',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.addFiles([ 'response.coffee', 'response/action.coffee', 'response/action/hangup.coffee', 'response/action/play.coffee', 'response/action/dial.coffee', 'response/action/reject.coffee', 'sipgate.coffee', 'call.coffee' ], "server");
  api.use('coffeescript');
  api.use('cfs:http-methods@0.0.29');
  api.export([ 'SipgateResponse', 'SipgateResponseAction', 'SipgateResponseActionHangup', 'SipgateResponseActionPlay', 'SipgateResponseActionDial', 'SipgateResponseActionReject', 'Sipgate', 'Call' ]);
});

Package.onTest(function(api) {
  api.use('coffeescript', "client");
  api.use([ 'tinytest', 'test-helpers' ], 'client');
  api.addFiles([ 'response.coffee', 'response/action.coffee', 'response/action/hangup.coffee', 'response/action/play.coffee', 'response/action/dial.coffee', 'response/action/reject.coffee', 'sipgate.coffee', 'call.coffee' ]);
  api.addFiles([ 'tests/client/call-tests.coffee', 'tests/client/io-tests.coffee', 'tests/client/response-tests.coffee' ], "client");
  api.export([ 'SipgateResponse', 'SipgateResponseAction', 'SipgateResponseActionHangup', 'SipgateResponseActionPlay', 'SipgateResponseActionDial', 'SipgateResponseActionReject', 'HTTP', 'Sipgate', 'Call' ]);
});
