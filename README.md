# Adrian

Robust and thorough job queue on top of MongoDB, featuring retries and timeouts.

<img height="484" width="417"
 src="https://raw.github.com/strathausen/node-adrian/master/images/Monk_Hawaii.jpg" />

## Usage

```js
var Queue = require('adrian');

var queue = new Queue('collection-name');

// Create job
var job = { some: 'data' };

// Enqueue job (and get a ticket ID)
queue.createJob(job, function(err, document) {
  // Job is in the queue.
  // Here's your ticket.
});

// Process job
queue.onJob(function(job, done) {
  // Crunch, crunch... your job processing goes here
  myJobProcessingLogic(job, function(err, result) {
    if (err) return done(err);
    // Must call done when finished
    done(null, result);
  });
});
```

## Configuration

Adrian comes with a few options.

```js
var queue = new Queue('collection-name', {options});

var defaults = {
  maxAttempts : 1,
  maxAge      : false, // maximum age of a job in seconds
  concurrency : 1,
  priority    : 1,
  polling     : 200
};
```

## Similar projects

- beanstalkd
- https://npmjs.org/package/mubsub
- https://npmjs.org/package/monq
- https://npmjs.org/package/mongomq
