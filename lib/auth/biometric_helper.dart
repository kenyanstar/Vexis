import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricHelper {
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  // Check if biometric authentication is available on the device
  Future<bool> isBiometricAvailable() async {
    try {
      // Check if the device supports biometrics
      final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      
      // Check if the device can authenticate with biometrics or device credentials
      final bool canAuthenticate = canAuthenticateWithBiometrics || 
          await _localAuth.isDeviceSupported();
      
      return canAuthenticate;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }
  
  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }
  
  // Authenticate with biometrics
  Future<bool> authenticate() async {
    try {
      final bool canAuthenticate = await isBiometricAvailable();
      
      if (!canAuthenticate) {
        debugPrint('Biometric authentication not available on this device');
        return false;
      }
      
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access VEXIS Browser',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Error authenticating: ${e.message}');
      
      // Handle specific error cases
      if (e.code == auth_error.notAvailable) {
        debugPrint('Biometric authentication not available');
      } else if (e.code == auth_error.notEnrolled) {
        debugPrint('No biometrics enrolled on this device');
      } else if (e.code == auth_error.lockedOut) {
        debugPrint('Biometric authentication locked out due to too many attempts');
      } else if (e.code == auth_error.permanentlyLockedOut) {
        debugPrint('Biometric authentication permanently locked out');
      }
      
      return false;
    } catch (e) {
      debugPrint('Error authenticating: $e');
      return false;
    }
  }
}