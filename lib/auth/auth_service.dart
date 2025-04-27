import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:vexis_browser/auth/biometric_helper.dart';
import 'package:vexis_browser/services/storage_service.dart';
import 'package:vexis_browser/core/constants.dart';

enum AuthMethod {
  email,
  phone,
  biometric,
}

class User {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  
  User({
    required this.uid, 
    required this.email,
    this.displayName,
    this.photoURL,
  });
}

class AuthException implements Exception {
  final String code;
  final String message;
  
  AuthException(this.code, this.message);
  
  @override
  String toString() => 'AuthException: $code - $message';
}

class AuthService {
  User? _currentUser;
  final BiometricHelper _biometricHelper = BiometricHelper();
  final StorageService _storageService = StorageService();
  final StreamController<User?> _authStateController = StreamController<User?>.broadcast();
  
  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _authStateController.stream;
  
  // Get current user
  User? get currentUser => _currentUser;
  
  // Check if user is authenticated
  bool get isAuthenticated => _currentUser != null;
  
  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Add globals.com suffix if not present
      if (!email.contains('@')) {
        email = '$email@globals.com';
      }
      
      // For demo, we'll validate a simple password rule
      if (password.length < 6) {
        throw AuthException(
          'weak-password',
          'Password should be at least 6 characters',
        );
      }
      
      // Mock user creation
      final user = User(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        displayName: email.split('@').first,
      );
      
      _currentUser = user;
      _authStateController.add(user);
      
      // Save auth state
      await _storageService.setBool(VexisConstants.prefLoggedIn, true);
      
      return user;
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }
  
  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      // Add globals.com suffix if not present
      if (!email.contains('@')) {
        email = '$email@globals.com';
      }
      
      // For demo, we'll validate a simple password rule
      if (password.length < 6) {
        throw AuthException(
          'weak-password',
          'Password should be at least 6 characters',
        );
      }
      
      // Mock user creation
      final user = User(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        displayName: email.split('@').first,
      );
      
      _currentUser = user;
      _authStateController.add(user);
      
      // Save auth state
      await _storageService.setBool(VexisConstants.prefLoggedIn, true);
      
      return user;
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }
  
  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      bool isAuthenticated = await _biometricHelper.authenticate();
      if (isAuthenticated) {
        // Create a demo user for biometric auth
        final user = User(
          uid: 'biometric-user',
          email: 'biometric@vexis.com',
          displayName: 'Biometric User',
        );
        
        _currentUser = user;
        _authStateController.add(user);
        
        // Mark as logged in locally
        await _storageService.setBool(VexisConstants.prefLoggedIn, true);
      }
      return isAuthenticated;
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }
  
  // Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    return await _biometricHelper.isBiometricAvailable();
  }
  
  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
    _authStateController.add(null);
    await _storageService.setBool(VexisConstants.prefLoggedIn, false);
  }
  
  // Password reset
  Future<void> resetPassword(String email) async {
    // Add globals.com suffix if not present
    if (!email.contains('@')) {
      email = '$email@globals.com';
    }
    
    // This would typically send a reset email
    // For demo purposes, we'll just print a message
    debugPrint('Password reset email sent to: $email');
  }
  
  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    if (_currentUser != null) {
      // Create a new user with updated info
      _currentUser = User(
        uid: _currentUser!.uid,
        email: _currentUser!.email,
        displayName: displayName ?? _currentUser!.displayName,
        photoURL: photoURL ?? _currentUser!.photoURL,
      );
      
      _authStateController.add(_currentUser);
    }
  }
  
  // Delete account
  Future<void> deleteAccount() async {
    _currentUser = null;
    _authStateController.add(null);
    await _storageService.setBool(VexisConstants.prefLoggedIn, false);
  }
  
  // Dispose resources
  void dispose() {
    _authStateController.close();
  }
}
