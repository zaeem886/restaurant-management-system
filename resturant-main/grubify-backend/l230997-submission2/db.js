const sql = require("mssql");

const dbConfig = {
  user: "sa",
  password: "12345678",
  database: "hi",
  server: "localhost\\SQLEXPRESS",
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  options: {
    encrypt: false,
    enableArithAbort: true,
    trustServerCertificate: true,
  },
};

// Establish database connection
const poolPromise = new sql.ConnectionPool(dbConfig)
  .connect()
  .then((pool) => {
    console.log("Connected to MSSQL Database");
    return pool;
  })
  .catch((err) => {
    console.error("Database Connection Failed! Error:", err);
  });

module.exports = { poolPromise, sql };
