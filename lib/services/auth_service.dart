import 'package:shared_preferences/shared_preferences.dart';
import 'hive_database_service.dart';
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

    // Create user using Hive
    _currentUser = await HiveDatabaseService.createUser(
      name: name,
      email: isEmail ? phoneOrEmail : '',
      phone: isEmail ? '' : phoneOrEmail,
      password: password, // In real app, this would be hashed
    );

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_currentUserIdKey, _currentUser!.id);

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

    // Authenticate using Hive
    _currentUser = await HiveDatabaseService.authenticateUser(
      identifier: phoneOrEmail,
      password: password,
    );

    if (_currentUser == null) {
      throw Exception('Invalid credentials');
    }

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_currentUserIdKey, _currentUser!.id);

    return _currentUser!;
  }

  // Send OTP for verification
  static Future<String> sendOTP(String phoneOrEmail) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Generate random 6-digit OTP
    String otp =
        (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();

    // In a real app, this would be sent via SMS or email
    print('OTP sent to $phoneOrEmail: $otp');

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
        _currentUser = await HiveDatabaseService.getUserById(userId);
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

    await HiveDatabaseService.setBiometricPreference(
      userId: _currentUser!.id,
      enabled: false,
    );
  }

  // Check if biometric is enabled for current user
  static Future<bool> isBiometricEnabled() async {
    if (_currentUser == null) return false;

    return await HiveDatabaseService.getBiometricPreference(_currentUser!.id);
  }
}
