var express = require('express');

// Constants
var PORT = 8080;

// App
var app = express();

app.use(express.static(__dirname + '/client'))
app.get('/info', function (req, res) {
  res.sendfile('info.html');
});
app.get('/client', function (req, res) {
  res.sendfile('client/index.html');
});
app.get('*', function (req, res) {
  res.sendfile('info.html');
});

app.listen(PORT);
console.log('Running REST-Test-Client on http://localhost:' + PORT+ '/client/');

var restify = require('restify');
var pgRestify = require('pg-restify');
var corsMiddleware = require('restify-cors-middleware');
 
var cors = corsMiddleware({
  preflightMaxAge: 5, //Optional 
  origins: ['*', 'http://localhost'],
  allowHeaders: ['API-Token'],
  exposeHeaders: ['API-Token-Expiry']
});
 
// create a simple restify server
var server = restify.createServer();
server.pre(cors.preflight);
server.use(cors.actual);

// add any additional custom server configuration

// add the pgRestify functionality
// by providing the restify instance
// and a server connection string
pgRestify.initialize({
  server: server,
  pgConfig: 'pg://nicokreiling:@localhost/testfahrten'
  //pgConfig: 'pg://nicokreiling:@localhost/testfahrten'
  //pgConfig: 'pg://postgres/mysecretpassword@192.168.99.100:5432/postgres'
}, function(err, pgRestifyInstance) {

  // now that the query to get table metadata is done,
  // start the server
  server.listen(8081);

});

console.log('Running REST Interface')