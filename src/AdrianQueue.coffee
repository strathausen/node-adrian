###

AdrianQueue

Enqueue jobs in MongoDB and poll for their status.

###

_        = require 'underscore'
async    = require 'async'
AdrianDB = require './AdrianDB'

class AdrianQueue
  module.exports = AdrianQueue
  constructor: (opts) ->
    @db = new AdrianDB opts

  ###

  Enqeue a job.

  cb(err, tickedId)

  ###
  put: (data, cb) =>
    @db.save { data }, (err, job) => cb err, job.id


  ###
  
  Query job status.

  cb(err, status, result)

  ###
  get: (id, cb) =>
    @db.findOne { id }, (err, job) => cb err, job?.status, job?.result
