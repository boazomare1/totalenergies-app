import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';

class CloudStorageService {
  static FirebaseFirestore? _firestore;
  static const String _usersCollection = 'users';

  /// Initialize Firestore
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _firestore = FirebaseFirestore.instance;
      print('Cloud storage initialized successfully');
    } catch (e) {
      print('Error initializing cloud storage: $e');
      rethrow;
    }
  }

  /// Get Firestore instance
  static FirebaseFirestore get firestore {
    if (_firestore == null) {
      throw Exception('Cloud storage not initialized. Call initialize() first.');
    }
    return _firestore!;
  }

  /// Create a new user in cloud storage
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

      await firestore
          .collection(_usersCollection)
          .doc(user.id)
          .set(user.toJson());

      print('User created in cloud storage: ${user.id}');
      return user;
    } catch (e) {
      print('Error creating user in cloud storage: $e');
      rethrow;
    }
  }

  /// Get user by email or phone from cloud storage
  static Future<UserModel?> getUserByEmailOrPhone(String identifier) async {
    try {
      // Search by email
      QuerySnapshot emailQuery = await firestore
          .collection(_usersCollection)
          .where('email', isEqualTo: identifier)
          .limit(1)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        return UserModel.fromJson(emailQuery.docs.first.data() as Map<String, dynamic>);
      }

      // Search by phone
      QuerySnapshot phoneQuery = await firestore
          .collection(_usersCollection)
          .where('phone', isEqualTo: identifier)
          .limit(1)
          .get();

      if (phoneQuery.docs.isNotEmpty) {
        return UserModel.fromJson(phoneQuery.docs.first.data() as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      print('Error getting user from cloud storage: $e');
      return null;
    }
  }

  /// Get user by ID from cloud storage
  static Future<UserModel?> getUserById(String id) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection(_usersCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting user by ID from cloud storage: $e');
      return null;
    }
  }

  /// Check if user exists in cloud storage
  static Future<bool> userExists(String identifier) async {
    try {
      final user = await getUserByEmailOrPhone(identifier);
      return user != null;
    } catch (e) {
      print('Error checking if user exists in cloud storage: $e');
      return false;
    }
  }

  /// Authenticate user with cloud storage
  static Future<UserModel?> authenticateUser({
    required String identifier,
    required String password,
  }) async {
    try {
      final user = await getUserByEmailOrPhone(identifier);
      if (user != null && user.password == password && user.isActive) {
        // Update last login
        await firestore
            .collection(_usersCollection)
            .doc(user.id)
            .update({
          'lastLoginAt': DateTime.now().toIso8601String(),
        });
        return user;
      }
      return null;
    } catch (e) {
      print('Error authenticating user in cloud storage: $e');
      return null;
    }
  }

  /// Update user in cloud storage
  static Future<void> updateUser(UserModel user) async {
    try {
      await firestore
          .collection(_usersCollection)
          .doc(user.id)
          .update(user.toJson());
      print('User updated in cloud storage: ${user.id}');
    } catch (e) {
      print('Error updating user in cloud storage: $e');
      rethrow;
    }
  }

  /// Set biometric preference in cloud storage
  static Future<void> setBiometricPreference({
    required String userId,
    required bool enabled,
    String? biometricType,
  }) async {
    try {
      await firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
        'biometricEnabled': enabled,
        'biometricType': biometricType,
      });
      print('Biometric preference updated in cloud storage: $userId');
    } catch (e) {
      print('Error setting biometric preference in cloud storage: $e');
      rethrow;
    }
  }

  /// Get biometric preference from cloud storage
  static Future<bool> getBiometricPreference(String userId) async {
    try {
      DocumentSnapshot doc = await firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['biometricEnabled'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error getting biometric preference from cloud storage: $e');
      return false;
    }
  }

  /// Delete user from cloud storage
  static Future<void> deleteUser(String userId) async {
    try {
      await firestore
          .collection(_usersCollection)
          .doc(userId)
          .delete();
      print('User deleted from cloud storage: $userId');
    } catch (e) {
      print('Error deleting user from cloud storage: $e');
      rethrow;
    }
  }
}