Package.describe({
  name: 'sipgate:io',
  version: '0.0.8',
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
  api.addFiles( [ 'io.coffee', 'call.coffee' ], "server" );
  api.use('coffeescript');
  api.use('cfs:http-methods@0.0.29');
  api.export([ 'Sipgate', 'Call' ]);
});

Package.onTest(function(api) {
  api.use('coffeescript', "client");
  api.use([ 'tinytest', 'test-helpers' ], 'client');
  api.addFiles([ 'io.coffee', 'call.coffee' ]);
  api.addFiles([ 'tests/client/call-tests.coffee', 'tests/client/io-tests.coffee' ], "client");
  api.export([ 'HTTP', 'Sipgate', 'Call' ]);
});
