import 'package:flutter/foundation.dart';
import 'package:vexis_browser/core/constants.dart';

class SuperTurboModeProvider extends ChangeNotifier {
  bool _isSuperTurboModeEnabled = false;
  int _dataSavedInBytes = 0;
  int _tapCount = 0;
  DateTime? _firstTapTime;
  
  // Getters
  bool get isSuperTurboModeEnabled => _isSuperTurboModeEnabled;
  int get dataSavedInBytes => _dataSavedInBytes;
  
  // Handle tap on turbo button to detect secret sequence
  void handleTap() {
    final now = DateTime.now();
    
    // Check if this is the first tap or if we need to reset the counter
    if (_firstTapTime == null || 
        now.difference(_firstTapTime!) > VexisConstants.superTurboTapWindow) {
      _firstTapTime = now;
      _tapCount = 1;
    } else {
      _tapCount++;
      
      // Check if the secret sequence is complete
      if (_tapCount >= VexisConstants.superTurboTapCount) {
        toggleSuperTurboMode();
        _tapCount = 0;
        _firstTapTime = null;
      }
    }
  }
  
  // Toggle super turbo mode
  void toggleSuperTurboMode() {
    _isSuperTurboModeEnabled = !_isSuperTurboModeEnabled;
    notifyListeners();
  }
  
  // Enable super turbo mode
  void enableSuperTurboMode() {
    if (!_isSuperTurboModeEnabled) {
      _isSuperTurboModeEnabled = true;
      notifyListeners();
    }
  }
  
  // Disable super turbo mode
  void disableSuperTurboMode() {
    if (_isSuperTurboModeEnabled) {
      _isSuperTurboModeEnabled = false;
      notifyListeners();
    }
  }
  
  // Add to data saved counter
  void addDataSaved(int bytes) {
    _dataSavedInBytes += bytes;
    notifyListeners();
  }
  
  // Reset data saved counter
  void resetDataSaved() {
    _dataSavedInBytes = 0;
    notifyListeners();
  }
  
  // Get formatted data saved string
  String getFormattedDataSaved() {
    // Convert bytes to appropriate unit
    if (_dataSavedInBytes < 1024) {
      return '$_dataSavedInBytes B';
    } else if (_dataSavedInBytes < 1024 * 1024) {
      final kb = (_dataSavedInBytes / 1024).toStringAsFixed(1);
      return '$kb KB';
    } else if (_dataSavedInBytes < 1024 * 1024 * 1024) {
      final mb = (_dataSavedInBytes / (1024 * 1024)).toStringAsFixed(1);
      return '$mb MB';
    } else {
      final gb = (_dataSavedInBytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
      return '$gb GB';
    }
  }
  
  // Get compression level
  int getCompressionLevel() {
    return VexisConstants.superTurboCompressionLevel;
  }
}