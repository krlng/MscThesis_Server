var config = {};

config.machine_ip = 'localhost'
config.db = {}
config.db.user = 'nicokreiling'
config.db.pw = ''

if (typeof(module) !== "undefined") {
  module.exports = config;
}