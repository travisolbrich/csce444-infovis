var mysql = require('mysql');
var http = require('http');
var express = require('express');
require('./sqlconn.js');

var server = http.createServer(function (request, response) {
	
	var connection = mysql.createConnection(sqlconn);

	connection.connect();

	connection.query('SELECT * from groups limit 1000', function(err, rows, fields) {
  		if (err) throw err;

  		response.writeHead(200, {"Content-Type": "application/json"});
  			response.end(JSON.stringify(rows));
		});

	connection.end();
});

server.listen(8080);
