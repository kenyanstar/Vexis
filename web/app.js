// VEXIS Browser Main JavaScript
document.addEventListener('DOMContentLoaded', () => {
  // Initialize the star background
  initStarsBackground();
  
  // Start the clock
  updateClock();
  setInterval(updateClock, 1000);

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
  const commandInput = document.getElementById('commandInput');
  const commandBtn = document.getElementById('commandBtn');
  
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
  let isSuperTurboMode = false; // Advanced data saving mode
  let isLowResourceMode = false; // Resource optimization mode
  let totalDataUsed = 0;
  let totalDataSaved = 0;
  let browsingHistory = [];
  let activeSearchEngine = 'google'; // Default search engine
  let zeroRatedDomains = ['wikipedia.org', 'example.org', 'wikimedia.org']; // Example zero-rated sites
  let installedWebApps = []; // List of installed web applications
  
  // Additional DOM elements for user profile
  const userProfileContainer = document.getElementById('userProfileContainer');
  const authButtonsContainer = document.getElementById('authButtonsContainer');
  const googleLoginBtn = document.getElementById('googleLoginBtn');
  const googleSignupBtn = document.getElementById('googleSignupBtn');
  const profilePic = document.getElementById('profilePic');
  const dropdownProfilePic = document.getElementById('dropdownProfilePic');
  const profileName = document.getElementById('profileName');
  const profileEmail = document.getElementById('profileEmail');
  const logoutBtn = document.getElementById('logoutBtn');
  
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
  
  // Stars background animation
  function initStarsBackground() {
    const starsContainer = document.getElementById('starsBackground');
    if (!starsContainer) return;
    
    const screenWidth = window.innerWidth;
    const screenHeight = window.innerHeight;
    
    // Create stars
    for (let i = 0; i < 100; i++) {
      createStar(starsContainer, screenWidth, screenHeight);
    }
    
    // Add shooting stars
    for (let i = 0; i < 3; i++) {
      createShootingStar(starsContainer, screenWidth, screenHeight);
      // Create new shooting stars periodically
      setInterval(() => {
        createShootingStar(starsContainer, screenWidth, screenHeight);
      }, 5000 + Math.random() * 10000); // Random interval between 5 and 15 seconds
    }
  }
  
  function createStar(container, maxWidth, maxHeight) {
    const star = document.createElement('div');
    star.className = 'star ' + (Math.random() > 0.8 ? 'large' : (Math.random() > 0.5 ? 'medium' : 'small'));
    
    // Random position
    star.style.left = Math.random() * maxWidth + 'px';
    star.style.top = Math.random() * maxHeight + 'px';
    
    // Random animation delay
    star.style.animationDelay = Math.random() * 5 + 's';
    star.style.animationDuration = 3 + Math.random() * 4 + 's';
    
    container.appendChild(star);
    return star;
  }
  
  function createShootingStar(container, maxWidth, maxHeight) {
    const star = document.createElement('div');
    star.className = 'star shooting';
    
    // Random starting position on left side
    star.style.left = Math.random() * (maxWidth / 4) + 'px';
    star.style.top = Math.random() * maxHeight / 2 + 'px';
    
    // Random animation duration
    star.style.animationDuration = 2 + Math.random() * 4 + 's';
    
    container.appendChild(star);
    
    // Remove the shooting star after animation completes
    setTimeout(() => {
      if (container.contains(star)) {
        container.removeChild(star);
      }
    }, parseFloat(star.style.animationDuration) * 1000);
    
    return star;
  }
  
  // Clock update function
  function updateClock() {
    const clockDisplay = document.getElementById('clockDisplay');
    if (!clockDisplay) return;
    
    const now = new Date();
    let hours = now.getHours();
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const ampm = hours >= 12 ? 'PM' : 'AM';
    
    // Convert to 12-hour format
    hours = hours % 12;
    hours = hours ? hours : 12; // 0 should be 12
    
    clockDisplay.textContent = `${hours}:${minutes} ${ampm}`;
  }
  
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
  
  // Google auth functionality
  googleLoginBtn.addEventListener('click', () => {
    simulateGoogleLogin();
  });
  
  googleSignupBtn.addEventListener('click', () => {
    simulateGoogleLogin();
  });
  
  // Function to simulate Google login for demo purposes
  function simulateGoogleLogin() {
    // This would normally open a popup to Google's OAuth service
    setTimeout(() => {
      // Simulate successful Google authentication
      user = {
        id: 123,
        username: 'googleuser',
        displayName: 'Google User',
        email: 'user@gmail.com',
        profilePicture: 'https://ui-avatars.com/api/?name=Google+User&background=4285F4&color=fff&size=100'
      };
      isLoggedIn = true;
      
      // Update UI
      updateLoginState();
      
      // Close any open modals
      closeModal(loginModal);
      closeModal(signupModal);
      
      alert('Successfully signed in with Google!');
    }, 1000);
  }
  
  // Add event listener for logout button in profile dropdown
  if (logoutBtn) {
    logoutBtn.addEventListener('click', handleLogout);
  }
  
  // Update UI based on login state
  function updateLoginState() {
    if (isLoggedIn && user) {
      // Hide auth buttons, show user profile
      authButtonsContainer.style.display = 'none';
      userProfileContainer.style.display = 'block';
      
      // Update profile information
      profilePic.src = user.profilePicture || 'https://ui-avatars.com/api/?name=' + encodeURIComponent(user.displayName) + '&background=4a6cf7&color=fff&size=100';
      dropdownProfilePic.src = user.profilePicture || 'https://ui-avatars.com/api/?name=' + encodeURIComponent(user.displayName) + '&background=4a6cf7&color=fff&size=100';
      profileName.textContent = user.displayName;
      profileEmail.textContent = user.email;
    } else {
      // Show auth buttons, hide user profile
      authButtonsContainer.style.display = 'flex';
      userProfileContainer.style.display = 'none';
    }
  }
  
  function handleLogout() {
    isLoggedIn = false;
    user = null;
    localStorage.removeItem('token');
    
    // Update UI state
    updateLoginState();
    
    // Redirect to welcome screen
    document.querySelector('.welcome-screen').style.display = 'flex';
    document.querySelector('.browser-iframe-container').style.display = 'none';
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

    // Check if URL is on zero-rated domains list
    const isZeroRated = zeroRatedDomains.some(domain => url.includes(domain));
    
    try {
      new URL(url); // Validate URL format
      
      // Show browser interface and hide welcome screen
      document.querySelector('.welcome-screen').style.display = 'none';
      document.querySelector('.browser-iframe-container').style.display = 'block';
      
      // Check if URL potentially contains video content
      const couldContainVideo = detectPotentialVideoContent(url);

      // Check if it looks like a web app that could be installed
      const couldBeWebApp = detectPotentialWebApp(url);
      
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
              .zero-rated {
                background: #e0f7ff;
                border: 1px solid #b8e6ff;
                border-radius: 4px;
                padding: 1rem;
                margin-top: 2rem;
                display: block;
              }
              .video-detected {
                background: #fff0e0;
                border: 1px solid #ffcc99;
                border-radius: 4px;
                padding: 1rem;
                margin-top: 2rem;
                display: block;
              }
              .webapp-installable {
                background: #f0e0ff;
                border: 1px solid #d9b3ff;
                border-radius: 4px;
                padding: 1rem;
                margin-top: 2rem;
                display: block;
              }
              .action-btn {
                background: #4a6cf7;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                font-weight: bold;
                margin-top: 8px;
                cursor: pointer;
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
                <strong>${isSuperTurboMode ? 'Super Turbo' : 'Turbo'} Mode Active:</strong> 
                Data compression enabled. Saved approximately ${isSuperTurboMode ? '75' : '45'}% data on this page.
                ${isSuperTurboMode ? '<div>Images and videos downsized to minimum quality.</div>' : ''}
              </div>
              
              ${isZeroRated ? `
                <div class="zero-rated">
                  <strong>Zero-Rated Website:</strong> This website doesn't count against your data plan.
                </div>
              ` : ''}
              
              ${couldContainVideo ? `
                <div class="video-detected">
                  <strong>Video Content Detected:</strong> Would you like to download this video?
                  <div>
                    <button class="action-btn" onclick="alert('Video download would start in the full version.')">Download Video</button>
                  </div>
                </div>
              ` : ''}
              
              ${couldBeWebApp ? `
                <div class="webapp-installable">
                  <strong>Web App Detected:</strong> Would you like to install this as an application?
                  <div>
                    <button class="action-btn" onclick="alert('Web App would be installed in the full version.')">Install App</button>
                  </div>
                </div>
              ` : ''}
            </div>
          </body>
        </html>
      `;
      
      // Update URL in address bar
      urlInput.value = url;
      
      // Add to history
      addToHistory(url);
      
      // Update connection status and data usage
      updateDataUsage(isZeroRated);
    } catch (error) {
      console.error('Invalid URL:', error);
      alert('Please enter a valid URL');
    }
  }
  
  // Detect potential video content
  function detectPotentialVideoContent(url) {
    const videoPatterns = [
      'youtube.com/watch', 
      'vimeo.com', 
      'dailymotion.com',
      'netflix.com',
      'hulu.com',
      'video',
      'stream',
      'player',
      '.mp4',
      '.webm',
      '.mkv',
      '.mov'
    ];
    
    return videoPatterns.some(pattern => url.toLowerCase().includes(pattern));
  }
  
  // Detect potential web app
  function detectPotentialWebApp(url) {
    const webAppPatterns = [
      'twitter.com',
      'facebook.com',
      'instagram.com',
      'linkedin.com',
      'github.com',
      'gmail.com',
      'docs.google.com',
      'office.com',
      'trello.com',
      'notion.so',
      'slack.com',
      'discord.com',
      'spotify.com',
      'web.whatsapp.com'
    ];
    
    return webAppPatterns.some(pattern => url.toLowerCase().includes(pattern));
  }
  
  goBtn.addEventListener('click', () => {
    navigateTo(urlInput.value);
  });
  
  urlInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      navigateTo(urlInput.value);
    }
  });
  
  // Search engine functionality
  const searchEngines = {
    google: {
      name: 'Google',
      searchUrl: 'https://www.google.com/search?q=',
      icon: '<svg viewBox="0 0 24 24" width="16" height="16"><path d="M12 12h10v4h-10z" fill="#EA4335"/><path d="M6.3 14.5l-1.3-3.5H6.9l.8 2.3 .8-2.3h.9l-1.3 3.5z" fill="#34A853"/><path d="M12.5 11c.7 0 1.3.6 1.3 1.3 0 .7-.6 1.3-1.3 1.3-.7 0-1.3-.6-1.3-1.3 0-.7.6-1.3 1.3-1.3z" fill="#4285F4"/><path d="M17.3 14.5L16 11h.9l.8 2.3L18.5 11h.9l-1.3 3.5z" fill="#FBBC05"/></svg>'
    },
    bing: {
      name: 'Bing',
      searchUrl: 'https://www.bing.com/search?q=',
      icon: '<svg viewBox="0 0 24 24" width="16" height="16"><path d="M5 3v12.5l3.5 1.5L15 15V8.5L8.5 11V3z" fill="#008373"/></svg>'
    },
    duckduckgo: {
      name: 'DuckDuckGo',
      searchUrl: 'https://duckduckgo.com/?q=',
      icon: '<svg viewBox="0 0 24 24" width="16" height="16"><path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10 10-4.5 10-10S17.5 2 12 2z" fill="#DE5833"/></svg>'
    },
    ecosia: {
      name: 'Ecosia',
      searchUrl: 'https://www.ecosia.org/search?q=',
      icon: '<svg viewBox="0 0 24 24" width="16" height="16"><path d="M12 2C6.5 2 2 6.5 2 12s4.5 10 10 10 10-4.5 10-10S17.5 2 12 2z" fill="#33AA48"/></svg>'
    }
  };
  
  function getSearchUrl(query) {
    return searchEngines[activeSearchEngine].searchUrl + encodeURIComponent(query);
  }
  
  searchBtn.addEventListener('click', () => {
    const query = searchInput.value;
    if (query) {
      // Check if it's a URL first
      if (/^(http|https):\/\//.test(query) || /^[\w-]+(\.[\w-]+)+/.test(query)) {
        navigateTo(query);
      } else {
        // Use the selected search engine
        navigateTo(getSearchUrl(query));
      }
    }
  });
  
  searchInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      const query = searchInput.value;
      if (query) {
        // Check if it's a URL first
        if (/^(http|https):\/\//.test(query) || /^[\w-]+(\.[\w-]+)+/.test(query)) {
          navigateTo(query);
        } else {
          // Use the selected search engine
          navigateTo(getSearchUrl(query));
        }
      }
    }
  });
  
  // Command bar functionality
  if (commandInput) {
    commandInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        handleCommand(commandInput.value);
      }
    });
  }
  
  if (commandBtn) {
    commandBtn.addEventListener('click', () => {
      handleCommand(commandInput.value);
    });
  }
  
  function handleCommand(command) {
    if (!command) return;
    
    // Special commands
    if (command.startsWith('/')) {
      const specialCommand = command.substring(1).toLowerCase();
      
      switch (specialCommand) {
        case 'turbo':
          toggleTurboMode();
          alert('Turbo Mode ' + (isTurboMode ? 'enabled' : 'disabled'));
          break;
        case 'superturbo':
          isTurboMode = true;
          isSuperTurboMode = true;
          turboBtn.classList.add('active');
          turboBtn.classList.add('super-active');
          alert('Super Turbo Mode enabled');
          break;
        case 'settings':
          openSettingsModal();
          break;
        case 'history':
          alert('Browsing history: ' + browsingHistory.join(', '));
          break;
        case 'bookmarks':
          alert('Bookmarks feature will be available soon');
          break;
        case 'downloads':
          alert('Downloads feature will be available soon');
          break;
        case 'help':
          alert('VEXIS Browser Command Help:\n/turbo - Toggle Turbo Mode\n/superturbo - Enable Super Turbo Mode\n/settings - Open Settings\n/history - Show History\n/bookmarks - Show Bookmarks\n/downloads - Show Downloads\n/help - Show this help');
          break;
        default:
          // Check if it's a URL first
          if (/^(http|https):\/\//.test(command) || /^[\w-]+(\.[\w-]+)+/.test(command)) {
            navigateTo(command);
          } else {
            // Use the selected search engine
            navigateTo(getSearchUrl(command));
          }
      }
    } else {
      // Check if it's a URL first
      if (/^(http|https):\/\//.test(command) || /^[\w-]+(\.[\w-]+)+/.test(command)) {
        navigateTo(command);
      } else {
        // Use the selected search engine
        navigateTo(getSearchUrl(command));
      }
    }
    
    // Clear command input after executing
    if (commandInput) {
      commandInput.value = '';
    }
  }
  
  // App tile click handlers
  document.querySelectorAll('.app-tile').forEach(tile => {
    tile.addEventListener('click', function() {
      const appName = this.querySelector('span').textContent;
      switch (appName) {
        case 'Gmail':
          navigateTo('https://mail.google.com');
          break;
        case 'Twitter':
          navigateTo('https://twitter.com');
          break;
        case 'DevTools':
          alert('Developer Tools will open in a dedicated panel in the full version');
          break;
        case 'YouTube':
          navigateTo('https://youtube.com');
          break;
        case 'Figma':
          navigateTo('https://figma.com');
          break;
        case 'GitHub':
          navigateTo('https://github.com');
          break;
        case 'Chrome':
          navigateTo('https://google.com');
          break;
        case 'Add':
          alert('You can add your favorite apps here in the full version');
          break;
      }
    });
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
    if (isSuperTurboMode) {
      // First click on an active super turbo mode turns it off
      isTurboMode = false;
      isSuperTurboMode = false;
      turboBtn.classList.remove('active');
      turboBtn.classList.remove('super-active');
      turboBtn.querySelector('span').textContent = 'TURBO';
      alert('Turbo Mode disabled.');
    } else if (isTurboMode) {
      // Second click activates Super Turbo mode
      isSuperTurboMode = true;
      turboBtn.classList.add('super-active');
      turboBtn.querySelector('span').textContent = 'SUPER TURBO';
      alert('Super Turbo Mode enabled! Maximum data saving active.');
    } else {
      // First click enables regular Turbo mode
      isTurboMode = true;
      turboBtn.classList.add('active');
      turboBtn.querySelector('span').textContent = 'TURBO';
      alert('Turbo Mode enabled! Data compression active.');
    }
    
    // If currently viewing a page, refresh it to show turbo mode state
    if (browserIframe.srcdoc) {
      const url = urlInput.value;
      if (url) navigateTo(url);
    }
    
    updateDataSavingDisplay();
  });
  
  function updateDataSavingDisplay() {
    let savingPercentage = 0;
    if (isTurboMode) savingPercentage = isSuperTurboMode ? 75 : 45;
    
    if (browserIframe.srcdoc && (isTurboMode || isSuperTurboMode)) {
      const dataSavingDiv = browserIframe.contentDocument.querySelector('.data-saving');
      if (dataSavingDiv) {
        dataSavingDiv.classList.add('active');
        dataSavingDiv.innerHTML = `
          <strong>${isSuperTurboMode ? 'Super Turbo' : 'Turbo'} Mode Active:</strong> 
          Data compression enabled. Saved approximately ${savingPercentage}% data on this page.
          ${isSuperTurboMode ? '<div>Images and videos downsized to minimum quality.</div>' : ''}
        `;
      }
    }
  }
  
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
  
  function updateDataUsage(isZeroRated = false) {
    if (isZeroRated) {
      // If zero-rated, don't add to data usage
      connectionStatus.textContent = 'Zero-Rated';
      connectionStatus.style.color = '#33AA48'; // Green color
      return;
    }
    
    // Simulate data usage for demo
    const pageSize = Math.floor(Math.random() * 2000) + 500; // 500-2500 KB
    
    // Apply data savings if in Turbo mode
    if (isTurboMode) {
      const savingsPercent = isSuperTurboMode ? 75 : Math.floor(Math.random() * 20) + 40;
      const actualDataUsed = Math.floor(pageSize * (1 - savingsPercent / 100));
      const savedAmount = pageSize - actualDataUsed;
      
      totalDataUsed += actualDataUsed;
      totalDataSaved += savedAmount;
      
      dataSaved.textContent = `Data Saved: ${formatDataSize(totalDataSaved)}`;
      connectionStatus.textContent = isSuperTurboMode ? 'Super Turbo' : 'Turbo Mode';
      connectionStatus.style.color = isSuperTurboMode ? 'var(--super-turbo-color)' : 'var(--turbo-color)';
    } else {
      totalDataUsed += pageSize;
      connectionStatus.textContent = 'Connected';
      connectionStatus.style.color = 'var(--gray)';
    }
    
    // If in low resource mode, add indicator
    if (isLowResourceMode) {
      connectionStatus.textContent += ' (Low Resource)';
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
    openSettingsModal();
  });
  
  // Settings Modal
  function openSettingsModal() {
    // Create modal if it doesn't exist
    let settingsModal = document.getElementById('settingsModal');
    
    if (!settingsModal) {
      settingsModal = document.createElement('div');
      settingsModal.id = 'settingsModal';
      settingsModal.className = 'modal';
      
      // Create modal content
      const modalContent = document.createElement('div');
      modalContent.className = 'modal-content';
      
      // Add close button
      const closeBtn = document.createElement('span');
      closeBtn.className = 'modal-close';
      closeBtn.innerHTML = '&times;';
      closeBtn.onclick = () => closeModal(settingsModal);
      
      // Add title
      const title = document.createElement('h2');
      title.textContent = 'Browser Settings';
      
      // Create settings container
      const settingsContainer = document.createElement('div');
      settingsContainer.className = 'settings-container';
      
      // Search Engine Settings
      const searchEngineSection = document.createElement('div');
      searchEngineSection.className = 'settings-section';
      
      const searchEngineTitle = document.createElement('h3');
      searchEngineTitle.textContent = 'Default Search Engine';
      searchEngineSection.appendChild(searchEngineTitle);
      
      const searchEngineSelector = document.createElement('div');
      searchEngineSelector.className = 'search-engine-selector';
      
      // Create search engine options
      Object.keys(searchEngines).forEach(engineKey => {
        const engine = searchEngines[engineKey];
        const option = document.createElement('div');
        option.className = `search-engine-option ${activeSearchEngine === engineKey ? 'active' : ''}`;
        option.innerHTML = `
          <div class="engine-icon">${engine.icon}</div>
          <span>${engine.name}</span>
        `;
        option.dataset.engine = engineKey;
        option.onclick = () => {
          // Update active search engine
          document.querySelectorAll('.search-engine-option').forEach(opt => opt.classList.remove('active'));
          option.classList.add('active');
          activeSearchEngine = engineKey;
        };
        searchEngineSelector.appendChild(option);
      });
      
      searchEngineSection.appendChild(searchEngineSelector);
      settingsContainer.appendChild(searchEngineSection);
      
      // Data Saving Settings
      const dataSavingSection = document.createElement('div');
      dataSavingSection.className = 'settings-section';
      
      const dataSavingTitle = document.createElement('h3');
      dataSavingTitle.textContent = 'Data Saving';
      dataSavingSection.appendChild(dataSavingTitle);
      
      // Turbo Mode toggle
      const turboModeToggle = createToggle(
        'Enable Turbo Mode', 
        'Reduces data usage by compressing web pages', 
        isTurboMode,
        (checked) => {
          isTurboMode = checked;
          if (!checked) {
            isSuperTurboMode = false;
            superTurboToggle.checked = false;
            superTurboToggle.disabled = true;
            turboBtn.classList.remove('active', 'super-active');
            turboBtn.querySelector('span').textContent = 'TURBO';
          } else {
            superTurboToggle.disabled = false;
            turboBtn.classList.add('active');
            turboBtn.querySelector('span').textContent = 'TURBO';
          }
        }
      );
      dataSavingSection.appendChild(turboModeToggle);
      
      // Super Turbo Mode toggle
      const superTurboToggle = createToggle(
        'Enable Super Turbo Mode', 
        'Maximum data savings with lower quality images and videos', 
        isSuperTurboMode,
        (checked) => {
          isSuperTurboMode = checked;
          if (checked) {
            turboBtn.classList.add('super-active');
            turboBtn.querySelector('span').textContent = 'SUPER TURBO';
          } else {
            turboBtn.classList.remove('super-active');
            turboBtn.querySelector('span').textContent = 'TURBO';
          }
        }
      );
      superTurboToggle.disabled = !isTurboMode;
      dataSavingSection.appendChild(superTurboToggle);
      
      // Zero-rated sites
      const zeroRatedSection = document.createElement('div');
      zeroRatedSection.className = 'zero-rated-sites';
      
      const zeroRatedTitle = document.createElement('h4');
      zeroRatedTitle.textContent = 'Zero-Rated Sites';
      zeroRatedSection.appendChild(zeroRatedTitle);
      
      const zeroRatedList = document.createElement('div');
      zeroRatedList.className = 'zero-rated-list';
      
      // Add existing zero-rated domains
      zeroRatedDomains.forEach(domain => {
        const domainItem = document.createElement('div');
        domainItem.className = 'zero-rated-item';
        domainItem.innerHTML = `
          <span>${domain}</span>
          <button class="remove-btn">✖</button>
        `;
        domainItem.querySelector('.remove-btn').onclick = () => {
          zeroRatedDomains = zeroRatedDomains.filter(d => d !== domain);
          domainItem.remove();
        };
        zeroRatedList.appendChild(domainItem);
      });
      
      // Add new zero-rated domain form
      const addZeroRatedForm = document.createElement('div');
      addZeroRatedForm.className = 'add-zero-rated';
      addZeroRatedForm.innerHTML = `
        <input type="text" placeholder="Add domain (e.g. example.org)" id="newZeroRatedDomain">
        <button class="button primary" id="addZeroRatedBtn">Add</button>
      `;
      
      zeroRatedSection.appendChild(zeroRatedList);
      zeroRatedSection.appendChild(addZeroRatedForm);
      dataSavingSection.appendChild(zeroRatedSection);
      
      settingsContainer.appendChild(dataSavingSection);
      
      // Developer Options
      const devOptionsSection = document.createElement('div');
      devOptionsSection.className = 'settings-section';
      
      const devOptionsTitle = document.createElement('h3');
      devOptionsTitle.textContent = 'Developer Options';
      devOptionsSection.appendChild(devOptionsTitle);
      
      // Low Resource Mode toggle
      const lowResourceToggle = createToggle(
        'Low Resource Mode', 
        'Optimizes browser to use minimal device resources', 
        isLowResourceMode,
        (checked) => {
          isLowResourceMode = checked;
          // Would apply resource limitations in a real implementation
        }
      );
      devOptionsSection.appendChild(lowResourceToggle);
      
      // Enable Developer Tools toggle
      const devToolsToggle = createToggle(
        'Enable Developer Tools', 
        'Show developer tools for debugging websites', 
        false,
        (checked) => {
          if (checked) {
            alert('Developer tools would be enabled in the full version');
          }
        }
      );
      devOptionsSection.appendChild(devToolsToggle);
      
      // Web App Installation
      const webAppSection = document.createElement('div');
      webAppSection.className = 'settings-section';
      
      const webAppTitle = document.createElement('h3');
      webAppTitle.textContent = 'Installed Web Apps';
      webAppSection.appendChild(webAppTitle);
      
      if (installedWebApps.length === 0) {
        const noApps = document.createElement('p');
        noApps.textContent = 'No web applications have been installed yet.';
        noApps.className = 'no-apps-message';
        webAppSection.appendChild(noApps);
      } else {
        const appsList = document.createElement('div');
        appsList.className = 'apps-list';
        
        installedWebApps.forEach(app => {
          const appItem = document.createElement('div');
          appItem.className = 'app-item';
          appItem.innerHTML = `
            <div class="app-icon">${app.icon || '🌐'}</div>
            <div class="app-info">
              <div class="app-name">${app.name}</div>
              <div class="app-url">${app.url}</div>
            </div>
            <button class="remove-btn">✖</button>
          `;
          appItem.querySelector('.remove-btn').onclick = () => {
            installedWebApps = installedWebApps.filter(a => a.url !== app.url);
            appItem.remove();
            
            if (installedWebApps.length === 0) {
              const noApps = document.createElement('p');
              noApps.textContent = 'No web applications have been installed yet.';
              noApps.className = 'no-apps-message';
              appsList.appendChild(noApps);
            }
          };
          appsList.appendChild(appItem);
        });
        
        webAppSection.appendChild(appsList);
      }
      
      settingsContainer.appendChild(devOptionsSection);
      settingsContainer.appendChild(webAppSection);
      
      // Add installation instructions
      const installInstructions = document.createElement('div');
      installInstructions.className = 'install-instructions';
      installInstructions.innerHTML = `
        <h3>Installing VEXIS Browser</h3>
        <p>To install VEXIS Browser on your device:</p>
        <ol>
          <li>Download the package from the official website</li>
          <li>Run the installer and follow the on-screen instructions</li>
          <li>Set VEXIS as your default browser for the best experience</li>
        </ol>
        <p>To share VEXIS with others, use the share button or send them the download link.</p>
        <button class="button primary" id="shareBtn">Share VEXIS Browser</button>
      `;
      
      settingsContainer.appendChild(installInstructions);
      
      // Assemble the modal
      modalContent.appendChild(closeBtn);
      modalContent.appendChild(title);
      modalContent.appendChild(settingsContainer);
      
      settingsModal.appendChild(modalContent);
      document.body.appendChild(settingsModal);
      
      // Add listeners for the new elements
      document.getElementById('addZeroRatedBtn').addEventListener('click', () => {
        const input = document.getElementById('newZeroRatedDomain');
        const domain = input.value.trim();
        
        if (domain && !zeroRatedDomains.includes(domain)) {
          zeroRatedDomains.push(domain);
          
          const domainItem = document.createElement('div');
          domainItem.className = 'zero-rated-item';
          domainItem.innerHTML = `
            <span>${domain}</span>
            <button class="remove-btn">✖</button>
          `;
          domainItem.querySelector('.remove-btn').onclick = () => {
            zeroRatedDomains = zeroRatedDomains.filter(d => d !== domain);
            domainItem.remove();
          };
          
          zeroRatedList.appendChild(domainItem);
          input.value = '';
        }
      });
      
      document.getElementById('shareBtn').addEventListener('click', () => {
        alert('Sharing functionality would be implemented in the full version');
      });
    }
    
    // Open the modal
    openModal(settingsModal);
  }
  
  // Helper function to create settings toggles
  function createToggle(label, description, initialState, onChange) {
    const container = document.createElement('div');
    container.className = 'settings-toggle';
    
    const toggle = document.createElement('label');
    toggle.className = 'switch';
    
    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.checked = initialState;
    checkbox.addEventListener('change', () => onChange(checkbox.checked));
    
    const slider = document.createElement('span');
    slider.className = 'slider';
    
    toggle.appendChild(checkbox);
    toggle.appendChild(slider);
    
    const info = document.createElement('div');
    info.className = 'toggle-info';
    
    const labelEl = document.createElement('div');
    labelEl.className = 'toggle-label';
    labelEl.textContent = label;
    
    const descEl = document.createElement('div');
    descEl.className = 'toggle-desc';
    descEl.textContent = description;
    
    info.appendChild(labelEl);
    info.appendChild(descEl);
    
    container.appendChild(toggle);
    container.appendChild(info);
    
    return container;
  }
});