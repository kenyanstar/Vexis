// VEXIS Browser Main JavaScript
document.addEventListener('DOMContentLoaded', () => {
  // DOM elements
  const loginBtn = document.getElementById('loginBtn');
  const signupBtn = document.getElementById('signupBtn');
  const loginModal = document.getElementById('loginModal');
  const signupModal = document.getElementById('signupModal');
  const loginForm = document.getElementById('loginForm');
  const signupForm = document.getElementById('signupForm');
  const switchToSignup = document.getElementById('switchToSignup');
  const switchToLogin = document.getElementById('switchToLogin');
  const closeButtons = document.querySelectorAll('.modal-close');
  
  // Browser controls
  const urlInput = document.getElementById('urlInput');
  const goBtn = document.getElementById('goBtn');
  const backBtn = document.getElementById('backBtn');
  const forwardBtn = document.getElementById('forwardBtn');
  const refreshBtn = document.getElementById('refreshBtn');
  const turboBtn = document.getElementById('turboBtn');
  const browserIframe = document.getElementById('browserIframe');
  const searchInput = document.getElementById('searchInput');
  const searchBtn = document.getElementById('searchBtn');
  
  // Footer elements
  const historyBtn = document.getElementById('historyBtn');
  const bookmarksBtn = document.getElementById('bookmarksBtn');
  const downloadsBtn = document.getElementById('downloadsBtn');
  const settingsBtn = document.getElementById('settingsBtn');
  const connectionStatus = document.getElementById('connectionStatus');
  const dataUsage = document.getElementById('dataUsage');
  const dataSaved = document.getElementById('dataSaved');
  
  // App state
  let isLoggedIn = false;
  let user = null;
  let isTurboMode = false;
  let totalDataUsed = 0;
  let totalDataSaved = 0;
  let browsingHistory = [];
  
  // API base URL
  const API_BASE = '/api';

  // Modal functionality
  function openModal(modal) {
    modal.style.display = 'block';
  }
  
  function closeModal(modal) {
    modal.style.display = 'none';
  }
  
  loginBtn.addEventListener('click', () => openModal(loginModal));
  signupBtn.addEventListener('click', () => openModal(signupModal));
  
  switchToSignup.addEventListener('click', (e) => {
    e.preventDefault();
    closeModal(loginModal);
    openModal(signupModal);
  });
  
  switchToLogin.addEventListener('click', (e) => {
    e.preventDefault();
    closeModal(signupModal);
    openModal(loginModal);
  });
  
  closeButtons.forEach(button => {
    button.addEventListener('click', function() {
      const modal = this.closest('.modal');
      closeModal(modal);
    });
  });
  
  // Close modal when clicking outside
  window.addEventListener('click', (e) => {
    if (e.target === loginModal) closeModal(loginModal);
    if (e.target === signupModal) closeModal(signupModal);
  });
  
  // Form submissions
  loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const username = document.getElementById('loginUsername').value;
    const password = document.getElementById('loginPassword').value;
    
    try {
      // In a real app, this would call the API
      console.log('Login attempt:', { username, password });
      
      /*
      // Example API call - uncomment when API is ready
      const response = await fetch(`${API_BASE}/auth/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ username, password })
      });
      
      if (!response.ok) {
        throw new Error('Login failed');
      }
      
      const data = await response.json();
      user = data.user;
      localStorage.setItem('token', data.token);
      isLoggedIn = true;
      */
      
      // For demo, simulate successful login
      user = {
        id: 1,
        username,
        displayName: username,
        email: 'user@example.com'
      };
      isLoggedIn = true;
      
      updateLoginState();
      closeModal(loginModal);
    } catch (error) {
      console.error('Login error:', error);
      alert('Login failed: ' + error.message);
    }
  });
  
  signupForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const username = document.getElementById('signupUsername').value;
    const email = document.getElementById('signupEmail').value;
    const password = document.getElementById('signupPassword').value;
    const displayName = document.getElementById('signupDisplayName').value || username;
    
    try {
      // In a real app, this would call the API
      console.log('Signup attempt:', { username, email, password, displayName });
      
      /*
      // Example API call - uncomment when API is ready
      const response = await fetch(`${API_BASE}/auth/register`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ username, email, password, displayName })
      });
      
      if (!response.ok) {
        throw new Error('Signup failed');
      }
      
      const data = await response.json();
      alert('Account created successfully! Please log in.');
      */
      
      // For demo, simulate successful signup
      alert('Account created successfully! You\'re now logged in.');
      
      // Auto-login after signup
      user = {
        id: 1,
        username,
        displayName,
        email
      };
      isLoggedIn = true;
      
      updateLoginState();
      closeModal(signupModal);
    } catch (error) {
      console.error('Signup error:', error);
      alert('Signup failed: ' + error.message);
    }
  });
  
  // Update UI based on login state
  function updateLoginState() {
    if (isLoggedIn) {
      loginBtn.textContent = 'Logout';
      loginBtn.removeEventListener('click', () => openModal(loginModal));
      loginBtn.addEventListener('click', handleLogout);
      
      signupBtn.textContent = user.displayName;
      signupBtn.classList.remove('primary');
      signupBtn.classList.add('secondary');
      signupBtn.removeEventListener('click', () => openModal(signupModal));
      signupBtn.addEventListener('click', openUserSettings);
    } else {
      loginBtn.textContent = 'Login';
      loginBtn.removeEventListener('click', handleLogout);
      loginBtn.addEventListener('click', () => openModal(loginModal));
      
      signupBtn.textContent = 'Sign Up';
      signupBtn.classList.add('primary');
      signupBtn.classList.remove('secondary');
      signupBtn.removeEventListener('click', openUserSettings);
      signupBtn.addEventListener('click', () => openModal(signupModal));
    }
  }
  
  function handleLogout() {
    isLoggedIn = false;
    user = null;
    localStorage.removeItem('token');
    updateLoginState();
  }
  
  function openUserSettings() {
    // TODO: Implement user settings modal
    alert('User settings will be available soon!');
  }
  
  // Browser navigation functionality
  function navigateTo(url) {
    if (!url) return;
    
    // Ensure URL has protocol
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://' + url;
    }
    
    try {
      new URL(url); // Validate URL format
      
      // Show browser interface and hide welcome screen
      document.querySelector('.welcome-screen').style.display = 'none';
      document.querySelector('.browser-iframe-container').style.display = 'block';
      
      // In a real implementation, this would navigate in the iframe or load through a proxy
      // For demo, we can direct to the URL (if allowed by security policies)
      // browserIframe.src = url;
      
      // For demo, show a placeholder message in the iframe
      browserIframe.srcdoc = `
        <html>
          <head>
            <style>
              body {
                font-family: sans-serif;
                margin: 2rem;
                line-height: 1.6;
                color: #333;
              }
              .demo-banner {
                background: #f0f4ff;
                border: 1px solid #d0d8ff;
                border-radius: 8px;
                padding: 2rem;
                text-align: center;
                max-width: 800px;
                margin: 3rem auto;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
              }
              h1 { color: #4a6cf7; }
              .url { 
                background: #eee; 
                padding: 0.5rem 1rem;
                border-radius: 4px;
                font-family: monospace;
                word-break: break-all;
              }
              .data-saving {
                background: #e7fff0;
                border: 1px solid #c3e6d1;
                border-radius: 4px;
                padding: 1rem;
                margin-top: 2rem;
                display: inline-block;
              }
              .data-saving.active {
                display: block;
              }
              .hidden {
                display: none;
              }
            </style>
          </head>
          <body>
            <div class="demo-banner">
              <h1>VEXIS Browser Demo</h1>
              <p>Demonstrating browsing to:</p>
              <p class="url">${url}</p>
              
              <div class="data-saving ${isTurboMode ? 'active' : 'hidden'}">
                <strong>Turbo Mode Active:</strong> Data compression enabled. Saved approximately 45% data on this page.
              </div>
            </div>
          </body>
        </html>
      `;
      
      // Update URL in address bar
      urlInput.value = url;
      
      // Add to history
      addToHistory(url);
      
      // Update connection status and data usage
      updateDataUsage();
    } catch (error) {
      console.error('Invalid URL:', error);
      alert('Please enter a valid URL');
    }
  }
  
  goBtn.addEventListener('click', () => {
    navigateTo(urlInput.value);
  });
  
  urlInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      navigateTo(urlInput.value);
    }
  });
  
  searchBtn.addEventListener('click', () => {
    const query = searchInput.value;
    if (query) {
      // Use a search engine
      navigateTo(`https://www.google.com/search?q=${encodeURIComponent(query)}`);
    }
  });
  
  searchInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      const query = searchInput.value;
      if (query) {
        navigateTo(`https://www.google.com/search?q=${encodeURIComponent(query)}`);
      }
    }
  });
  
  backBtn.addEventListener('click', () => {
    // For demo, just log the action
    console.log('Back button clicked');
    alert('Back navigation would be implemented in the full version');
  });
  
  forwardBtn.addEventListener('click', () => {
    // For demo, just log the action
    console.log('Forward button clicked');
    alert('Forward navigation would be implemented in the full version');
  });
  
  refreshBtn.addEventListener('click', () => {
    // For demo, refresh the current "page"
    if (browserIframe.srcdoc) {
      const currentSrcdoc = browserIframe.srcdoc;
      browserIframe.srcdoc = '';
      setTimeout(() => {
        browserIframe.srcdoc = currentSrcdoc;
      }, 100);
    }
  });
  
  turboBtn.addEventListener('click', () => {
    isTurboMode = !isTurboMode;
    
    if (isTurboMode) {
      turboBtn.classList.add('active');
      alert('Turbo Mode enabled! Data compression active.');
    } else {
      turboBtn.classList.remove('active');
      alert('Turbo Mode disabled.');
    }
    
    // If currently viewing a page, refresh it to show turbo mode state
    if (browserIframe.srcdoc) {
      const url = urlInput.value;
      if (url) navigateTo(url);
    }
  });
  
  // History, bookmarks and user data functions
  function addToHistory(url) {
    // In a real implementation, this would call the API if user is logged in
    const entry = {
      id: Date.now(),
      url: url,
      title: url, // In a real browser, this would be the page title
      visitedAt: new Date().toISOString()
    };
    
    browsingHistory.unshift(entry);
    
    // Keep history to a reasonable size for the demo
    if (browsingHistory.length > 100) {
      browsingHistory = browsingHistory.slice(0, 100);
    }
    
    console.log('Added to history:', entry);
  }
  
  function updateDataUsage() {
    // Simulate data usage for demo
    const pageSize = Math.floor(Math.random() * 2000) + 500; // 500-2500 KB
    totalDataUsed += pageSize;
    
    if (isTurboMode) {
      // Simulate data savings (40-60%)
      const savingsPercent = Math.floor(Math.random() * 20) + 40;
      const savedAmount = Math.floor(pageSize * (savingsPercent / 100));
      totalDataSaved += savedAmount;
      
      dataSaved.textContent = `Data Saved: ${formatDataSize(totalDataSaved)}`;
    }
    
    dataUsage.textContent = `Data Used: ${formatDataSize(totalDataUsed)}`;
  }
  
  function formatDataSize(sizeInKB) {
    if (sizeInKB < 1000) {
      return `${sizeInKB} KB`;
    } else {
      return `${(sizeInKB / 1000).toFixed(2)} MB`;
    }
  }
  
  // Footer button handlers
  historyBtn.addEventListener('click', () => {
    alert('Browsing history feature will be available soon!');
  });
  
  bookmarksBtn.addEventListener('click', () => {
    alert('Bookmarks feature will be available soon!');
  });
  
  downloadsBtn.addEventListener('click', () => {
    alert('Downloads feature will be available soon!');
  });
  
  settingsBtn.addEventListener('click', () => {
    alert('Settings feature will be available soon!');
  });
});