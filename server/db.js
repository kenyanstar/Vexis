const { Pool } = require('pg');
const { drizzle } = require('drizzle-orm/pg-pool');
const schema = require("../shared/schema.js");

if (!process.env.DATABASE_URL) {
  throw new Error(
    "DATABASE_URL must be set. Did you forget to provision a database?",
  );
}

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const db = drizzle(pool, { schema });

module.exports = {
  pool,
  db
};