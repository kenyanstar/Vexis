import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  // Initialize the service - call this before using other methods
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Get a boolean value
  bool getBool(String key, {bool defaultValue = false}) {
    if (_prefs == null) {
      debugPrint('StorageService not initialized');
      return defaultValue;
    }
    return _prefs!.getBool(key) ?? defaultValue;
  }
  
  // Set a boolean value
  Future<bool> setBool(String key, bool value) async {
    if (_prefs == null) {
      debugPrint('StorageService not initialized');
      return false;
    }
    return await _prefs!.setBool(key, value);
  }
  
  // Get a string value
  String getString(String key, {String defaultValue = ''}) {
    if (_prefs == null) {
      debugPrint('StorageService not initialized');
      return defaultValue;
    }
    return _prefs!.getString(key) ?? defaultValue;
  }
  
  // Set a string value
  Future<bool> setString(String key, String value) async {
    if (_prefs == null) {
      debugPrint('StorageService not initialized');
      return false;
    }
    return await _prefs!.setString(key, value);
  }
  
  // Get an integer value
  int getInt(String key, {int defaultValue = 0}) {
    if (_prefs == null) {
      debugPrint('StorageService not initialized');
      return defaultValue;
    }
    return _prefs!.getInt(key) ?? defaultValue;
  }
  
  // Set an integer value
  Future<bool> setInt(String key, int value) async {
    if (_prefs == null) {
      debugPrint('StorageService not initialized');
      return false;
    }
    return await _prefs!.setInt(key, value);
  }
  
  // Remove a value
  Future<bool> remove(String key) async {
    if (_prefs == null) {
      debugPrint('StorageService not initialized');
      return false;
    }
    return await _prefs!.remove(key);
  }
  
  // Clear all values
  Future<bool> clear() async {
    if (_prefs == null) {
      debugPrint('StorageService not initialized');
      return false;
    }
    return await _prefs!.clear();
  }
}