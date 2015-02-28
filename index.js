var kue = require('kue');
var redis = require('kue/node_modules/redis');
var config = require('../config');

kue.redis.createClientFactory = function() {
  var client = redis.createClient(config.kue.redis.port, config.kue.redis.host);
  client.auth(config.kue.redis.auth);
  client.on('error', function(err) {
    console.log('REDIS::connection error', err);
  });
  client.on('reconnecting', function() {
    console.log('REDIS::reconnecting...');
  });
  return client;
};
module.exports = kue;
