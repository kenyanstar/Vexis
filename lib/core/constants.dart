import 'package:flutter/material.dart';

class VexisConstants {
  // App-wide constants
  static const String appName = 'VEXIS Browser';
  static const String appVersion = '1.0.0';
  
  // URLs
  static const String defaultHomePage = 'https://www.google.com';
  static const String defaultSearchEngine = 'https://www.google.com/search?q=';
  
  // API Endpoints
  static const String turboProxyEndpoint = 'https://api.vexis.com/turbo/proxy';
  
  // Animation durations
  static const Duration splashScreenDuration = Duration(milliseconds: 2000);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  
  // Shared preferences keys
  static const String prefTurboMode = 'turbo_mode_enabled';
  static const String prefSuperTurboMode = 'super_turbo_mode_enabled';
  static const String prefFirstLaunch = 'first_launch';
  static const String prefDataSaved = 'data_saved_bytes';
  static const String prefLastTab = 'last_tab_url';
  static const String prefLoggedIn = 'user_logged_in';
  
  // Turbo mode settings
  static const int turboCompressionLevel = 80; // Percentage
  static const int superTurboCompressionLevel = 95; // Percentage
  
  // Super Turbo Mode activation tap count
  static const int superTurboTapCount = 5;
  static const Duration superTurboTapWindow = Duration(milliseconds: 3000);
}

class VexisColors {
  // App Theme Colors
  static const Color primaryBlue = Color(0xFF005DFF);
  static const Color secondaryPurple = Color(0xFF7F00FF);
  static const Color backgroundColor = Color(0xFF0A0A0A);
  static const Color textColor = Color(0xFFF8F9FA);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color warningColor = Color(0xFFFFCC00);
  static const Color successColor = Color(0xFF34C759);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF005DFF),
    Color(0xFF7F00FF),
  ];
  
  static const List<Color> superTurboGradient = [
    Color(0xFF7F00FF),
    Color(0xFFFF3B30),
  ];
  
  // Shield Logo Colors
  static const Color shieldOutline = Color(0xFF005DFF);
  static const Color shieldFill = Color(0xFF0A0A0A);
  static const Color shieldHighlight = Color(0xFF7F00FF);
}
