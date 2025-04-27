const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const port = process.env.API_PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('web')); // Serve static files from 'web' directory

// DB Initialization
let db = null;
const initDb = async () => {
  try {
    // Use regular module.exports style
    const db = require('./db.js');
    // Verify DB connection
    await db.pool.query('SELECT NOW()');
    console.log('Database connection successful');
  } catch (error) {
    console.error('Database connection error:', error);
  }
};

// Simple route for testing
app.get('/api/status', (req, res) => {
  res.json({ status: 'ok', message: 'VEXIS Browser API is running', timestamp: new Date() });
});

// User routes
app.get('/api/users/:id', async (req, res) => {
  try {
    const { storage } = require('./storage');
    const user = await storage.getUser(parseInt(req.params.id));
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    // Don't return the password hash
    const { passwordHash, ...userWithoutPassword } = user;
    res.json(userWithoutPassword);
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/users', async (req, res) => {
  try {
    const { storage } = require('./storage');
    const { username, email, password, displayName } = req.body;
    
    // Validate required fields
    if (!username || !email || !password) {
      return res.status(400).json({ error: 'Username, email and password are required' });
    }
    
    // Check if user exists
    const existingUser = await storage.getUserByUsername(username);
    if (existingUser) {
      return res.status(409).json({ error: 'Username already taken' });
    }
    
    const existingEmail = await storage.getUserByEmail(email);
    if (existingEmail) {
      return res.status(409).json({ error: 'Email already in use' });
    }
    
    // In a real app, we would hash the password here
    const passwordHash = password; // This should be hashed in production!
    
    const newUser = await storage.createUser({
      username,
      email,
      passwordHash,
      displayName,
      biometricEnabled: false,
      createdAt: new Date(),
      updatedAt: new Date()
    });
    
    // Don't return the password hash
    const { passwordHash: _, ...userWithoutPassword } = newUser;
    res.status(201).json(userWithoutPassword);
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// User preferences routes
app.get('/api/users/:userId/preferences', async (req, res) => {
  try {
    const { storage } = require('./storage');
    const preferences = await storage.getUserPreferences(parseInt(req.params.userId));
    if (!preferences) {
      return res.status(404).json({ error: 'Preferences not found' });
    }
    res.json(preferences);
  } catch (error) {
    console.error('Error fetching preferences:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/users/:userId/preferences', async (req, res) => {
  try {
    const { storage } = require('./storage');
    const userId = parseInt(req.params.userId);
    const { darkMode, turboModeEnabled, superTurboModeEnabled, dataSavedInBytes } = req.body;
    
    const preferences = await storage.getUserPreferences(userId);
    
    if (preferences) {
      // Update existing preferences
      const updatedPreferences = await storage.updateUserPreferences(userId, {
        darkMode,
        turboModeEnabled,
        superTurboModeEnabled,
        dataSavedInBytes,
        lastSyncedAt: new Date()
      });
      res.json(updatedPreferences);
    } else {
      // Create new preferences
      const newPreferences = await storage.createUserPreferences({
        userId,
        darkMode: darkMode !== undefined ? darkMode : true,
        turboModeEnabled: turboModeEnabled !== undefined ? turboModeEnabled : false,
        superTurboModeEnabled: superTurboModeEnabled !== undefined ? superTurboModeEnabled : false,
        dataSavedInBytes: dataSavedInBytes || 0,
        lastSyncedAt: new Date()
      });
      res.status(201).json(newPreferences);
    }
  } catch (error) {
    console.error('Error updating preferences:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Browsing history routes
app.get('/api/users/:userId/history', async (req, res) => {
  try {
    const { storage } = require('./storage');
    const limit = req.query.limit ? parseInt(req.query.limit) : 100;
    const history = await storage.getBrowsingHistory(parseInt(req.params.userId), limit);
    res.json(history);
  } catch (error) {
    console.error('Error fetching history:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/users/:userId/history', async (req, res) => {
  try {
    const { storage } = require('./storage');
    const userId = parseInt(req.params.userId);
    const { url, title, faviconUrl } = req.body;
    
    if (!url) {
      return res.status(400).json({ error: 'URL is required' });
    }
    
    const newEntry = await storage.addHistoryEntry({
      userId,
      url,
      title: title || '',
      faviconUrl,
      visitedAt: new Date()
    });
    
    res.status(201).json(newEntry);
  } catch (error) {
    console.error('Error adding history entry:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.delete('/api/users/:userId/history', async (req, res) => {
  try {
    const { storage } = require('./storage');
    await storage.clearBrowsingHistory(parseInt(req.params.userId));
    res.status(204).send();
  } catch (error) {
    console.error('Error clearing history:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Start server
const startServer = async () => {
  await initDb();
  app.listen(port, () => {
    console.log(`VEXIS Browser API server running on port ${port}`);
  });
};

startServer();

module.exports = app; // Export for testing