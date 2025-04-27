// Simple migration script to create database tables directly
require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function migrate() {
  console.log('Starting database migration...');
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create users table
    await client.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        username VARCHAR(100) NOT NULL UNIQUE,
        email VARCHAR(255) NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        display_name VARCHAR(100),
        biometric_enabled BOOLEAN DEFAULT false,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW()
      )
    `);
    console.log('Created users table');
    
    // Create user_preferences table
    await client.query(`
      CREATE TABLE IF NOT EXISTS user_preferences (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        dark_mode BOOLEAN DEFAULT true,
        turbo_mode_enabled BOOLEAN DEFAULT false,
        super_turbo_mode_enabled BOOLEAN DEFAULT false,
        data_saved_in_bytes INTEGER DEFAULT 0,
        last_synced_at TIMESTAMP DEFAULT NOW()
      )
    `);
    console.log('Created user_preferences table');
    
    // Create browsing_history table
    await client.query(`
      CREATE TABLE IF NOT EXISTS browsing_history (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        url TEXT NOT NULL,
        title TEXT,
        visited_at TIMESTAMP NOT NULL DEFAULT NOW(),
        favicon_url TEXT
      )
    `);
    console.log('Created browsing_history table');
    
    // Create bookmark_folders table first (it self-references)
    await client.query(`
      CREATE TABLE IF NOT EXISTS bookmark_folders (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        parent_folder_id INTEGER REFERENCES bookmark_folders(id) ON DELETE SET NULL,
        name VARCHAR(100) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW()
      )
    `);
    console.log('Created bookmark_folders table');
    
    // Create bookmarks table
    await client.query(`
      CREATE TABLE IF NOT EXISTS bookmarks (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        folder_id INTEGER REFERENCES bookmark_folders(id) ON DELETE SET NULL,
        url TEXT NOT NULL,
        title TEXT NOT NULL,
        favicon_url TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT NOW()
      )
    `);
    console.log('Created bookmarks table');
    
    // Create downloads table
    await client.query(`
      CREATE TABLE IF NOT EXISTS downloads (
        id SERIAL PRIMARY KEY,
        user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        url TEXT NOT NULL,
        filename TEXT NOT NULL,
        file_size INTEGER,
        mime_type VARCHAR(100),
        status VARCHAR(20) NOT NULL DEFAULT 'in_progress',
        started_at TIMESTAMP NOT NULL DEFAULT NOW(),
        completed_at TIMESTAMP
      )
    `);
    console.log('Created downloads table');
    
    await client.query('COMMIT');
    console.log('Database migration completed successfully!');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Migration failed:', error);
    throw error;
  } finally {
    client.release();
    await pool.end();
  }
}

migrate().catch(console.error);