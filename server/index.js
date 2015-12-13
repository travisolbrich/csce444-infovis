var mysql = require('mysql');
var express = require('express');
var app = express();
var cors = require('cors');
var sqlconn = require('./sqlconn.js');
app.use(cors({origin: true}));

app.get('/words/frequency', function(req, res) {

    var connection = mysql.createConnection(sqlconn.conn());
    connection.connect();

    connection.query('SELECT count(*) as occurrences, word FROM flickr.group_relations_word group by word order by occurrences', function (err, rows, fields) {
        if (err) throw err;

        res.send({nodes: rows});
    });

    connection.end();
});

app.get('/relations/word/:word', function(req, res) {

    var connection = mysql.createConnection(sqlconn.conn());
    connection.connect();

    connection.query("select * from group_relations_word where word = '" + req.params.word + "'", function (err, rows, fields) {
        if (err) throw err;

        res.send(JSON.stringify(rows));
    });

    connection.end();
});

app.get('/groups/word/:word/:minGroupSize', function(req, res) {

    var connection = mysql.createConnection(sqlconn.conn());
    connection.connect();

    connection.query("call groups_with_word_relation('"+req.params.word+"',"+req.params.minGroupSize+")", function (err, rows, fields) {
        if (err) throw err;

        res.send(JSON.stringify(rows[0]));
    });

    connection.end();
});


app.get('/group/:groupId', function(req, res) {

    var connection = mysql.createConnection(sqlconn.conn());
    connection.connect();

    connection.query("select * from groups where groupId = '" + req.params.groupId + "'", function (err, rows, fields) {
        if (err) throw err;

        res.send(JSON.stringify(rows));
    });

    connection.end();
});

app.get('/group/:groupId/users', function(req, res) {

    var connection = mysql.createConnection(sqlconn.conn());
    connection.connect();

    connection.query("select u.userId, nickname, isAdmin from users u join groups_users gu on gu.userId = u.userId where gu.groupId = '" + req.params.groupId + "'", function (err, rows, fields) {
        if (err) throw err;

        res.send(JSON.stringify(rows));
    });

    connection.end();
});

app.listen(8080);
