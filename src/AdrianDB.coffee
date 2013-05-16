async = require 'async'

class AdrianDB
  module.exports = AdrianDB
  constructor: (opts) ->
    @opts = _.defaults opts,
      db             : 'localhost/node-adrian-queue'
      collection     : 'jobs'

  ###
  
  Perform actions to set the queue up on a fresh database

  ###
  setup: (cb) =>
    indexes = [[ 'counter', 1 ], [ 'since', 1 ], [ 'reserved', 1 ]]
    async.series [
      (cb) => @db.createCollection  @opts.collection, cb
      (cb) => @db.ensureIndex indexes, no, cb
    ], cb


