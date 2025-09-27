import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if fingerprint authentication is available
  static Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final hasEnrolledBiometrics = await isBiometricEnrolled();
      final availableBiometrics = await getAvailableBiometrics();

      // Only allow fingerprint authentication
      final hasFingerprint =
          availableBiometrics.contains(BiometricType.fingerprint) ||
          availableBiometrics.contains(BiometricType.strong);

      print('Fingerprint check:');
      print('- Can check biometrics: $isAvailable');
      print('- Device supported: $isDeviceSupported');
      print('- Has enrolled biometrics: $hasEnrolledBiometrics');
      print('- Has fingerprint: $hasFingerprint');

      return isAvailable &&
          isDeviceSupported &&
          hasEnrolledBiometrics &&
          hasFingerprint;
    } catch (e) {
      print('Error checking fingerprint availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate with fingerprint only
  static Future<bool> authenticateWithBiometric({
    String reason = 'Authenticate with your fingerprint',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        throw Exception('Fingerprint authentication is not available');
      }

      final result = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true, // Only use biometric, no fallback
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );

      return result;
    } on PlatformException catch (e) {
      print(
        'Platform exception during biometric auth: ${e.code} - ${e.message}',
      );

      if (e.code == auth_error.notAvailable) {
        throw Exception(
          'Biometric authentication is not available on this device',
        );
      } else if (e.code == auth_error.notEnrolled) {
        throw Exception(
          'No biometric data is enrolled. Please set up biometric authentication in your device settings.',
        );
      } else if (e.code == auth_error.lockedOut) {
        throw Exception(
          'Biometric authentication is temporarily locked. Please try again later.',
        );
      } else if (e.code == auth_error.permanentlyLockedOut) {
        throw Exception(
          'Biometric authentication is permanently locked. Please use your device passcode to unlock.',
        );
      } else if (e.code == 'UserCancel') {
        throw Exception('Authentication was cancelled by user');
      } else if (e.code == 'SystemCancel') {
        throw Exception('Authentication was cancelled by system');
      } else {
        throw Exception(
          'Biometric authentication failed: ${e.message ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('Error during biometric authentication: $e');
      throw Exception('Biometric authentication failed: ${e.toString()}');
    }
  }

  /// Check if biometric is enrolled
  static Future<bool> isBiometricEnrolled() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      print('Error checking biometric enrollment: $e');
      return false;
    }
  }

  /// Get biometric type name
  static String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }

  /// Get all available biometric type names
  static Future<List<String>> getAvailableBiometricNames() async {
    try {
      final biometrics = await getAvailableBiometrics();
      return biometrics.map((type) => getBiometricTypeName(type)).toList();
    } catch (e) {
      print('Error getting biometric names: $e');
      return [];
    }
  }

  /// Get detailed biometric information for testing
  static Future<Map<String, dynamic>> getBiometricInfo() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final availableBiometrics = await getAvailableBiometrics();
      final biometricNames = await getAvailableBiometricNames();
      final isEnrolled = await isBiometricEnrolled();
      final isAvailable = await isBiometricAvailable();

      return {
        'canCheckBiometrics': canCheckBiometrics,
        'isDeviceSupported': isDeviceSupported,
        'availableBiometrics': availableBiometrics,
        'biometricNames': biometricNames,
        'isEnrolled': isEnrolled,
        'isAvailable': isAvailable,
        'biometricCount': availableBiometrics.length,
      };
    } catch (e) {
      print('Error getting biometric info: $e');
      return {'error': e.toString(), 'isAvailable': false};
    }
  }

  /// Simulate biometric authentication (for testing)
  static Future<bool> simulateBiometricAuth({
    String reason = 'Authenticate to access your account',
  }) async {
    try {
      // Simulate a delay
      await Future.delayed(const Duration(seconds: 2));

      // For simulation, we'll return true 90% of the time
      // In a real app, this would be replaced with actual biometric authentication
      final random = DateTime.now().millisecondsSinceEpoch % 10;
      return random < 9; // 90% success rate
    } catch (e) {
      print('Error during simulated biometric authentication: $e');
      return false;
    }
  }

  /// Check if biometric authentication should be used
  static Future<bool> shouldUseBiometric() async {
    try {
      final isAvailable = await isBiometricAvailable();
      final isEnrolled = await isBiometricEnrolled();
      return isAvailable && isEnrolled;
    } catch (e) {
      print('Error checking biometric preference: $e');
      return false;
    }
  }
}
