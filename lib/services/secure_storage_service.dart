import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys for secure storage
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _currentUserIdKey = 'current_user_id';
  static const String _userDataKey = 'user_data';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricTypeKey = 'biometric_type';

  /// Initialize secure storage
  static Future<void> initialize() async {
    try {
      // Test if secure storage is available
      await _storage.containsKey(key: 'test');
      print('Secure storage initialized successfully');
    } catch (e) {
      print('Error initializing secure storage: $e');
      rethrow;
    }
  }

  /// Save user data securely
  static Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _storage.write(key: _userDataKey, value: userJson);
      await _storage.write(key: _currentUserIdKey, value: user.id);
      print('User data saved securely: ${user.id}');
    } catch (e) {
      print('Error saving user data: $e');
      rethrow;
    }
  }

  /// Get user data from secure storage
  static Future<UserModel?> getUser() async {
    try {
      final userJson = await _storage.read(key: _userDataKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Get user by ID (for compatibility)
  static Future<UserModel?> getUserById(String id) async {
    try {
      final user = await getUser();
      if (user != null && user.id == id) {
        return user;
      }
      return null;
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  /// Get user by email or phone
  static Future<UserModel?> getUserByEmailOrPhone(String identifier) async {
    try {
      final user = await getUser();
      if (user != null && 
          (user.email == identifier || user.phone == identifier)) {
        return user;
      }
      return null;
    } catch (e) {
      print('Error getting user by email or phone: $e');
      return null;
    }
  }

  /// Check if user exists
  static Future<bool> userExists(String identifier) async {
    try {
      final user = await getUserByEmailOrPhone(identifier);
      return user != null;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  /// Authenticate user
  static Future<UserModel?> authenticateUser({
    required String identifier,
    required String password,
  }) async {
    try {
      final user = await getUserByEmailOrPhone(identifier);
      if (user != null && user.password == password && user.isActive) {
        // Update last login time
        final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
        await saveUser(updatedUser);
        return updatedUser;
      }
      return null;
    } catch (e) {
      print('Error authenticating user: $e');
      return null;
    }
  }

  /// Create user
  static Future<UserModel> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        password: password,
        createdAt: DateTime.now(),
      );

      await saveUser(user);
      return user;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Update user
  static Future<void> updateUser(UserModel user) async {
    try {
      await saveUser(user);
      print('User updated in secure storage: ${user.id}');
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Set login state
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await _storage.write(key: _isLoggedInKey, value: isLoggedIn.toString());
    } catch (e) {
      print('Error setting login state: $e');
      rethrow;
    }
  }

  /// Get login state
  static Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await _storage.read(key: _isLoggedInKey);
      return isLoggedIn == 'true';
    } catch (e) {
      print('Error getting login state: $e');
      return false;
    }
  }

  /// Set biometric preference
  static Future<void> setBiometricPreference({
    required String userId,
    required bool enabled,
    String? biometricType,
  }) async {
    try {
      await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
      if (biometricType != null) {
        await _storage.write(key: _biometricTypeKey, value: biometricType);
      }
      print('Biometric preference saved: $enabled');
    } catch (e) {
      print('Error setting biometric preference: $e');
      rethrow;
    }
  }

  /// Get biometric preference
  static Future<bool> getBiometricPreference(String userId) async {
    try {
      final enabled = await _storage.read(key: _biometricEnabledKey);
      return enabled == 'true';
    } catch (e) {
      print('Error getting biometric preference: $e');
      return false;
    }
  }

  /// Get biometric type
  static Future<String?> getBiometricType() async {
    try {
      return await _storage.read(key: _biometricTypeKey);
    } catch (e) {
      print('Error getting biometric type: $e');
      return null;
    }
  }

  /// Clear all data (logout)
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      print('All secure storage data cleared');
    } catch (e) {
      print('Error clearing secure storage: $e');
      rethrow;
    }
  }

  /// Delete specific user data
  static Future<void> deleteUser(String userId) async {
    try {
      await _storage.delete(key: _userDataKey);
      await _storage.delete(key: _currentUserIdKey);
      await _storage.delete(key: _biometricEnabledKey);
      await _storage.delete(key: _biometricTypeKey);
      print('User data deleted from secure storage: $userId');
    } catch (e) {
      print('Error deleting user data: $e');
      rethrow;
    }
  }
}