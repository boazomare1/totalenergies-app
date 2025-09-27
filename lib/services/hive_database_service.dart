import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class HiveDatabaseService {
  static const String _usersBoxName = 'users';
  static const String _settingsBoxName = 'settings';
  static const String _biometricBoxName = 'biometric';

  static Box<UserModel>? _usersBox;
  static Box<dynamic>? _settingsBox;
  static Box<dynamic>? _biometricBox;

  /// Initialize Hive database
  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      // Register adapters
      Hive.registerAdapter(UserModelAdapter());

      // Open boxes
      _usersBox = await Hive.openBox<UserModel>(_usersBoxName);
      _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);
      _biometricBox = await Hive.openBox<dynamic>(_biometricBoxName);

      print('Hive database initialized successfully');
    } catch (e) {
      print('Error initializing Hive database: $e');
      rethrow;
    }
  }

  /// Get users box
  static Box<UserModel> get usersBox {
    if (_usersBox == null) {
      throw Exception(
        'Hive database not initialized. Call initialize() first.',
      );
    }
    return _usersBox!;
  }

  /// Get settings box
  static Box<dynamic> get settingsBox {
    if (_settingsBox == null) {
      throw Exception(
        'Hive database not initialized. Call initialize() first.',
      );
    }
    return _settingsBox!;
  }

  /// Get biometric box
  static Box<dynamic> get biometricBox {
    if (_biometricBox == null) {
      throw Exception(
        'Hive database not initialized. Call initialize() first.',
      );
    }
    return _biometricBox!;
  }

  /// User Management Methods

  /// Create a new user
  static Future<UserModel> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Check if user already exists
      if (await userExists(email) || await userExists(phone)) {
        throw Exception('User with this email or phone already exists');
      }

      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        password: password, // In real app, hash this password
        createdAt: DateTime.now(),
      );

      await usersBox.put(user.id, user);
      print('User created successfully: ${user.id}');
      return user;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Get user by email or phone
  static Future<UserModel?> getUserByEmailOrPhone(String identifier) async {
    try {
      for (final user in usersBox.values) {
        if (user.email == identifier || user.phone == identifier) {
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Get user by ID
  static Future<UserModel?> getUserById(String id) async {
    try {
      return usersBox.get(id);
    } catch (e) {
      print('Error getting user by ID: $e');
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
        // Update last login
        user.lastLoginAt = DateTime.now();
        await usersBox.put(user.id, user);
        return user;
      }
      return null;
    } catch (e) {
      print('Error authenticating user: $e');
      return null;
    }
  }

  /// Update user
  static Future<void> updateUser(UserModel user) async {
    try {
      await usersBox.put(user.id, user);
      print('User updated successfully: ${user.id}');
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Delete user
  static Future<void> deleteUser(String userId) async {
    try {
      await usersBox.delete(userId);
      print('User deleted successfully: $userId');
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Get all users (for testing)
  static List<UserModel> getAllUsers() {
    try {
      return usersBox.values.toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  /// Settings Management

  /// Set setting value
  static Future<void> setSetting(String key, dynamic value) async {
    try {
      await settingsBox.put(key, value);
    } catch (e) {
      print('Error setting $key: $e');
    }
  }

  /// Get setting value
  static T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      return settingsBox.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      print('Error getting $key: $e');
      return defaultValue;
    }
  }

  /// Biometric Management

  /// Set biometric preference for user
  static Future<void> setBiometricPreference({
    required String userId,
    required bool enabled,
    String? biometricType,
  }) async {
    try {
      final user = await getUserById(userId);
      if (user != null) {
        user.biometricEnabled = enabled;
        user.biometricType = biometricType;
        await updateUser(user);
      }
    } catch (e) {
      print('Error setting biometric preference: $e');
    }
  }

  /// Get biometric preference for user
  static Future<bool> getBiometricPreference(String userId) async {
    try {
      final user = await getUserById(userId);
      return user?.biometricEnabled ?? false;
    } catch (e) {
      print('Error getting biometric preference: $e');
      return false;
    }
  }

  /// Store biometric test data
  static Future<void> storeBiometricTestData({
    required String userId,
    required Map<String, dynamic> testData,
  }) async {
    try {
      await biometricBox.put('${userId}_test_data', testData);
    } catch (e) {
      print('Error storing biometric test data: $e');
    }
  }

  /// Get biometric test data
  static Map<String, dynamic>? getBiometricTestData(String userId) {
    try {
      return biometricBox.get('${userId}_test_data') as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting biometric test data: $e');
      return null;
    }
  }

  /// Clear all data (for testing)
  static Future<void> clearAllData() async {
    try {
      await usersBox.clear();
      await settingsBox.clear();
      await biometricBox.clear();
      print('All data cleared');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  /// Get database statistics
  static Map<String, int> getDatabaseStats() {
    try {
      return {
        'users': usersBox.length,
        'settings': settingsBox.length,
        'biometric_data': biometricBox.length,
      };
    } catch (e) {
      print('Error getting database stats: $e');
      return {};
    }
  }

  /// Close all boxes
  static Future<void> close() async {
    try {
      await _usersBox?.close();
      await _settingsBox?.close();
      await _biometricBox?.close();
      print('Hive database closed');
    } catch (e) {
      print('Error closing database: $e');
    }
  }
}
