// Simple Express web server for the HTML version of VEXIS Browser
require('dotenv').config();
const express = require('express');
const path = require('path');
const app = express();
const port = process.env.WEB_PORT || 5000;

// Serve static files from the web directory
app.use(express.static(path.join(__dirname, '../web')));

// Serve the main HTML file for any route not handled
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../web/index.html'));
});

// Start the server
app.listen(port, '0.0.0.0', () => {
  console.log(`VEXIS Browser web server running at http://0.0.0.0:${port}`);
});