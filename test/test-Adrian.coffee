_      = require 'underscore'
async  = require 'async'
assert = require 'assert'
Adrian = require '..'

# Jobs to process
jobs = []

# See what we have got
processedJobs = []

# Fake job processor
processJob = (job, cb) ->
  processedJobs.push job
  do cb

# Helper function to check if a job has been found
has = (path) -> _.any processedJobs, (job) -> job.path is path

suite 'Adrian', ->
  test 'setup jobs', (done) ->
    return done err if err

    # Date for expired reservations, old jobs
    expired = new Date
    expired.setMinutes (new Date).getMinutes() - 1

    # Fresh, unreserved job
    jobs.push testJob
    # Reserved job younger than a minute but not yet retried
    jobs.push _.extend {}, testJob,
      (path: 'youngNoTry', since: Date.now(), reserved: '12345')
    # Reserved job older than a minute and not yet retried
    jobs.push _.extend {}, testJob,
      (path: 'oldNoTry',   since: expired, reserved: '12345')
    # Reserved job older than a minute and retried 1, 2 or 3 times
    jobs.push _.extend {}, testJob,
      (path: 'youngTry1',  since: expired, reserved: '12345', counter: 1)
    jobs.push _.extend {}, testJob,
      (path: 'youngTry2',  since: expired, reserved: '12345', counter: 2)
    jobs.push _.extend {}, testJob,
      (path: 'youngTry3',  since: expired, reserved: '12345', counter: 3)
    # Fresh, unreserved job on a different jobline
    jobs.push _.extend {}, testJob,
      (path: 'wrongLine',  jobline: 'another')

    # Save jobs to DB
    async.forEach jobs, (dbTester.modelSaver 'jobq'), (err) ->
      return done err if err
      upcloadWorker = new UpcloadWorker
        jobline: 'testline', mongoose: db, logger: (log: ->)
      # Make it fake!
      upcloadWorker.processJob = processJob
      upcloadWorker.wait = ->
        done null
        upcloadWorker.wait = ->
      # Start finding jobs
      upcloadWorker.start()

  suite 'Finding and not finding jobs', ->
    test 'found an unreserverd job', ->
      assert has 'testJob'

    test 'not found a reserverd job younger than 1m and not retried', ->
      assert not has 'youngNoTry'

    test 'found a job older that 1m', ->
      assert has 'oldNoTry'

    test 'found a reserved job older than 1m retried more than 1 times', ->
      assert has 'youngTry1'

    test 'found a reserved job older than 1m retried more than 2 times', ->
      assert has 'youngTry2'

    test 'not found a reserved job older than 1m retried more than 3 times', ->
      assert not has 'youngTry3'

    test 'not found an unreserved job on another jobline', ->
      assert not has 'wrongLine'

    test 'counter of has been incremented', (done) ->
      Job.findOne (path: 'testJob'), (err, job) ->
        assert.equal job.counter, 1
        done err

