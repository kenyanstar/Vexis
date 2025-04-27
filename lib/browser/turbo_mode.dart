import 'package:flutter/foundation.dart';
import 'package:vexis_browser/core/constants.dart';

class TurboModeProvider extends ChangeNotifier {
  bool _isTurboModeEnabled = false;
  int _dataSavedInBytes = 0;
  
  // Getters
  bool get isTurboModeEnabled => _isTurboModeEnabled;
  int get dataSavedInBytes => _dataSavedInBytes;
  
  // Toggle turbo mode
  void toggleTurboMode() {
    _isTurboModeEnabled = !_isTurboModeEnabled;
    notifyListeners();
  }
  
  // Enable turbo mode
  void enableTurboMode() {
    if (!_isTurboModeEnabled) {
      _isTurboModeEnabled = true;
      notifyListeners();
    }
  }
  
  // Disable turbo mode
  void disableTurboMode() {
    if (_isTurboModeEnabled) {
      _isTurboModeEnabled = false;
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
    return VexisConstants.turboCompressionLevel;
  }
}