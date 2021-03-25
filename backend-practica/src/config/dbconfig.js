var mysql = require('mysql');

const config = {
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'practica1s2021',
    port: 3306
};

const pool = mysql.createPool(config);

module.exports = pool;