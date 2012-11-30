# Adrian

Robust and thorough job queue on top of MongoDB, featuring retries and timeouts.

<img src='https://raw.github.com/strathausen/node-adrian/master/images/Monk_Hawaii.jpg' />

## Usage

```js
var Queue = require('adrian');

var queue = new Queue;

// Creating jobs
var job = { some: 'data' };

queue.put(job, function(err, result) {
  if(err) {
    console.log('something went wrong:', err);
    return;
  };
  console.log('Yay, we have a result:', result);
});

// Working on jobs
queue.on('job', function(job, cb) {
  // crunch crunch
  workOnJobAsynchroneously(job, function(err, result) {
    if(err) return cb(err);
    // everything is fine, transmit the result
    cb(null, result);
  }
});
```

## Configuration

Adrian comes with a few options.

```js
var queue = new Queue({
  // MongoDB connection String
  // default mongodb://localhost/node-adrian
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
```
