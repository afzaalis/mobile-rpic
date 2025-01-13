const mysql = require('mysql2');  


const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'rpic',
  port: 3307,
});


const promiseDb = db.promise();  
module.exports = promiseDb; 
