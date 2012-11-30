# Monqo

Robust job queue on top of MongoDB, with retries.

## Usage

```js
var Queue = require('monq');

var queue = new Queue({
  // MongoDB connection String
  // default mongodb://localhost/node-monq
  db: process.env.MONGODB,

  // Polling interval for new jobs
  // default 470ms
  poll: 600,

  // How many times will a job be retried if an error has occured?
  // default 0 times
  retryOnError: 2,

  // How many times will a job be retried if an timeout has occured?
  // default 3 times
  retryOnTimeout: 5,

  // If a job has not been finished after this time,
  // then the job will be worked on again.
  // default 10000ms
  expires: 5000,

  // Only work on that many jobs at once
  // default 3
  concurrency: 7
});

// spawning jobs
queue.on('job', function(job, cb) {
  // crunch crunch
  workOnJobAsynchroneously(job, function(err, result) {
    if(err) return cb(err);
    // everything is fine, transmit the result
    cb(null, result);
  }
});

var job = { some: 'data' };

queue.put(job, functino(err, result) {
  if(err) {
    console.log('something went wrong:', err);
    return;
  };
  console.log('Yay, we have a result:', result);
});
```
