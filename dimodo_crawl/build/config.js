"use strict";
var _a = require("pg"), Pool = _a.Pool, Client = _a.Client;
var pool = new Pool({
    user: "present",
    host: "localhost",
    database: "dimodo",
    password: "your-password",
    port: 5432
});
var client = new Client({
    user: "present",
    host: "localhost",
    database: "dimodo",
    password: "your-password",
    port: 5432
});
var db = {
    getDB: function () {
        client
            .connect()
            .then(function () { return console.log("connected successfully"); })
            .then(function () { return client.query("SELECT sid FROM cosmetics_products"); })
            .then(function (results) { return console.table(results.rows); })["catch"](function (e) { return console.log; })["finally"](function () { return client.end(); });
    }
};
module.exports = db;
