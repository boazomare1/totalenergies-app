import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'hive_database_service.dart';
import 'secure_storage_service.dart';
import 'notification_service.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _currentUserIdKey = 'current_user_id';

  // Current user
  static UserModel? _currentUser;

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    if (isLoggedIn && _currentUser == null) {
      await loadUserData();
    }

    return isLoggedIn && _currentUser != null;
  }

  // Get current user data
  static UserModel? getCurrentUser() {
    return _currentUser;
  }

  // Update current user data
  static Future<void> updateCurrentUser(UserModel user) async {
    _currentUser = user;
  }

  // Register user with phone or email
  static Future<UserModel> registerUser({
    required String phoneOrEmail,
    required String name,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Validate input
    if (phoneOrEmail.isEmpty || name.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    // Check if it's email or phone
    bool isEmail = phoneOrEmail.contains('@');

    if (isEmail && !_isValidEmail(phoneOrEmail)) {
      throw Exception('Invalid email format');
    }

    if (!isEmail && !_isValidPhone(phoneOrEmail)) {
      throw Exception('Invalid phone number format');
    }

    // Validate password strength
    if (!_isStrongPassword(password)) {
      throw Exception(
        'Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character',
      );
    }

    // Hash password for security
    String hashedPassword = _hashPassword(password);

    // Check if user already exists in both secure storage and Hive
    bool existsInSecure = await SecureStorageService.userExists(phoneOrEmail);
    bool existsInHive = await HiveDatabaseService.userExists(phoneOrEmail);

    if (existsInSecure || existsInHive) {
      throw Exception(
        'User with this ${isEmail ? 'email' : 'phone number'} already exists',
      );
    }

    // Create user in secure storage
    _currentUser = await SecureStorageService.createUser(
      name: name,
      email: isEmail ? phoneOrEmail : '',
      phone: isEmail ? '' : phoneOrEmail,
      password: hashedPassword,
    );

    // Also create in local Hive for offline access
    await HiveDatabaseService.createUser(
      name: name,
      email: isEmail ? phoneOrEmail : '',
      phone: isEmail ? '' : phoneOrEmail,
      password: hashedPassword,
    );

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_currentUserIdKey, _currentUser!.id);

    // Log successful registration
    print('User registered successfully: ${_currentUser!.id}');

    return _currentUser!;
  }

  // Login user
  static Future<UserModel> loginUser({
    required String phoneOrEmail,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Validate input
    if (phoneOrEmail.isEmpty || password.isEmpty) {
      throw Exception('Phone/Email and password are required');
    }

    // Check if it's email or phone
    bool isEmail = phoneOrEmail.contains('@');

    if (isEmail && !_isValidEmail(phoneOrEmail)) {
      throw Exception('Invalid email format');
    }

    if (!isEmail && !_isValidPhone(phoneOrEmail)) {
      throw Exception('Invalid phone number format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Hash the provided password for comparison
    String hashedPassword = _hashPassword(password);

    // Authenticate using secure storage first, then fallback to local
    _currentUser = await SecureStorageService.authenticateUser(
      identifier: phoneOrEmail,
      password: hashedPassword,
    );

    // Fallback to local storage if secure storage fails
    if (_currentUser == null) {
      _currentUser = await HiveDatabaseService.authenticateUser(
        identifier: phoneOrEmail,
        password: hashedPassword,
      );
    }

    if (_currentUser == null) {
      throw Exception('Invalid credentials');
    }

    // Check if account is active
    if (!_currentUser!.isActive) {
      throw Exception('Account has been deactivated. Please contact support.');
    }

    // Update last login time in secure storage
    final updatedUser = _currentUser!.copyWith(lastLoginAt: DateTime.now());
    await SecureStorageService.updateUser(updatedUser);
    await HiveDatabaseService.updateUser(updatedUser);
    _currentUser = updatedUser;

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_currentUserIdKey, _currentUser!.id);

    // Log successful login
    print('User logged in successfully: ${_currentUser!.id}');

    return _currentUser!;
  }

  // Send OTP for verification
  static Future<String> sendOTP(String phoneOrEmail) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Generate random 6-digit OTP
    String otp =
        (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();

    // Send OTP as notification
    await NotificationService.showNotification(
      title: 'TotalEnergies Verification',
      body: 'Your verification code is: $otp\nValid for 5 minutes',
      payload: 'auth_verification',
    );

    return otp;
  }

  // Verify OTP
  static Future<bool> verifyOTP(String phoneOrEmail, String otp) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would verify against the backend
    // For demo purposes, accept any 6-digit OTP
    if (otp.length == 6 && RegExp(r'^\d+$').hasMatch(otp)) {
      // Mark user as verified
      if (_currentUser != null) {
        final updatedUser = _currentUser!.copyWith(
          isEmailVerified: true,
          isPhoneVerified: true,
        );
        await HiveDatabaseService.updateUser(updatedUser);
        _currentUser = updatedUser;
      }
      return true;
    }

    return false;
  }

  // Logout user
  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_currentUserIdKey);
  }

  // Load user data from storage
  static Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    if (isLoggedIn) {
      final userId = prefs.getString(_currentUserIdKey);
      if (userId != null) {
        // Try secure storage first, then fallback to local
        _currentUser = await SecureStorageService.getUserById(userId);
        if (_currentUser == null) {
          _currentUser = await HiveDatabaseService.getUserById(userId);
        }
      }
    }
  }

  // Helper methods
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool _isValidPhone(String phone) {
    // Accept various phone formats
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return cleaned.length >= 10 && cleaned.length <= 15;
  }

  static bool _isStrongPassword(String password) {
    // Password must be at least 8 characters and contain:
    // - At least one uppercase letter
    // - At least one lowercase letter
    // - At least one digit
    // - At least one special character
    if (password.length < 8) return false;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );

    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }

  static String _hashPassword(String password) {
    // Use SHA-256 for password hashing
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Get user display name
  static String getUserDisplayName() {
    return _currentUser?.name ?? 'Guest';
  }

  // Get user contact info
  static String getUserContact() {
    if (_currentUser != null) {
      return _currentUser!.phone.isNotEmpty
          ? _currentUser!.phone
          : _currentUser!.email;
    }
    return '';
  }

  // Check if user is verified
  static bool isUserVerified() {
    return _currentUser?.isEmailVerified ?? false;
  }

  // Biometric authentication methods
  static Future<bool> authenticateWithBiometric() async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    // Check if biometric is enabled for this user
    final biometricEnabled = await HiveDatabaseService.getBiometricPreference(
      _currentUser!.id,
    );
    if (!biometricEnabled) {
      throw Exception('Biometric authentication is not enabled for this user');
    }

    // This would integrate with BiometricService
    // For now, return true for testing
    return true;
  }

  // Enable biometric for current user
  static Future<void> enableBiometric(String biometricType) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    await SecureStorageService.setBiometricPreference(
      userId: _currentUser!.id,
      enabled: true,
      biometricType: biometricType,
    );
    await HiveDatabaseService.setBiometricPreference(
      userId: _currentUser!.id,
      enabled: true,
      biometricType: biometricType,
    );
  }

  // Disable biometric for current user
  static Future<void> disableBiometric() async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    await SecureStorageService.setBiometricPreference(
      userId: _currentUser!.id,
      enabled: false,
    );
    await HiveDatabaseService.setBiometricPreference(
      userId: _currentUser!.id,
      enabled: false,
    );
  }

  // Check if biometric is enabled for current user
  static Future<bool> isBiometricEnabled() async {
    if (_currentUser == null) return false;

    // Try secure storage first, then fallback to local
    bool enabled = await SecureStorageService.getBiometricPreference(
      _currentUser!.id,
    );
    if (!enabled) {
      enabled = await HiveDatabaseService.getBiometricPreference(
        _currentUser!.id,
      );
    }
    return enabled;
  }
}
