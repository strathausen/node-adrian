mongo            = require 'mongoskin'
{ EventEmitter } = require 'events'

class Adrian extends EventEmitter
  module.exports = Adrian
  constructor: (opts) ->
    @opts = _.defaults opts,
      db             : 'localhost/node-adrian-queue'
      collection     : 'jobs'
      poll           : 470
      retryOnError   : 2
      retryOnTimeout : 5
      expires        : 10000
      concurrency    : 3

    @db = mongo.db(@opts.db).collection(@opts.collection)

  ###
  
  Perform actions to set the queue up on a fresh database

  ###
  setup: (cb) =>
    indexes = [[ 'counter', 1 ], [ 'since', 1 ], [ 'reserved', 1 ]]
    async.series [
      (cb) => @db.createCollection  @opts.collection, cb
      (cb) => @db.ensureIndex indexes, no, cb
    ], cb

  ###

  Enqeue a job.

  cb(err, tickedId)

  ###
  put: (job, cb) =>
    @db.save job, {}, cb

  ###

  Retrieve a new job from the database and reserve it
  
  ###
  getNewJob: =>
    expired = new Date
    expired.setMinutes (new Date).getMinutes() - 1
    # Either one should match
    query = $or: [
      # Has been around for more than a minute
      counter:
        $lte: 2
      since:
        $lt: expired
    ,
      # Has not been reserved yet
      reserved: ''
    ]

    # Properties to be changed in the job
    update =
      # Increment the retry counter
      $inc     : (counter: 1)
      since    : Date.now()
      reserved : yes

    sort = []

    @db.findAndModify query, sort, update, {}, (err, job) =>
      return do @wait unless job

      @db.save job, (err) =>
        do @getNewJob
