**Welcome, stranger! There's nothing to see here yet. Move along and check back in a few days!**

# Adrian

Robust and thorough job queue on top of MongoDB, featuring retries and timeouts.

<img height="484" width="417"
 src="https://raw.github.com/strathausen/node-adrian/master/images/Monk_Hawaii.jpg" />

## Usage

```js
var Queue = require('adrian');

var queue = new Queue;

// Some data object describing what you want to do
var job = { some: 'data' };

// Enqueuing job
queue.put(job, function(err, ticketId) {
  // Job is in the queue, here's your ticket.
});

// Working on jobs
queue.on('job', function(job, done) {
  // Crunch, crunch... your job processing goes here
  myJobProcessingLogic(job, function(err, result) {
    if (err) return done(err);
    // Must call done when finished
    done(null, result);
  }
});

// Optional: getting job result and status via ticketId
queue.get(ticketId, function(err, result, status) {
  // err    : Error while getting status
  // result : Your custom result object, null if not yet done.
  // status : /(waiting|processing|done|timeout|error)/
}
```

## Configuration

Adrian comes with a few options.

```js
var queue = new Queue({
  // MongoDB connection String
  // default mongodb://localhost/node-adrian-queue
  db: process.env.MONGODB,

  // The collection to use
  // default 'jobs'
  collection: 'queue'

  // Polling interval for new jobs in milliseconds
  // default 470ms
  poll: 600,

  // How many times a job will be retried if an error has occured.
  // default 0 times
  retryOnError: 2,

  // How many times a job will be retried if a timeout has occured.
  // default 3 times
  retryOnTimeout: 5,

  // Job that have not been finished after this much time, will be retried.
  // default 10000ms
  expires: 5000,

  // Only work on that many jobs at once
  // default 3
  concurrency: 7
});
```

## Similar projects

- https://npmjs.org/package/mubsub
- https://npmjs.org/package/monq
- https://npmjs.org/package/mongomq
