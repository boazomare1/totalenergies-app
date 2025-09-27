import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _phoneKey = 'phone_number';
  static const String _emailKey = 'email';
  static const String _nameKey = 'user_name';

  // User data model
  static Map<String, dynamic>? _currentUser;

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get current user data
  static Map<String, dynamic>? getCurrentUser() {
    return _currentUser;
  }

  // Register user with phone or email
  static Future<Map<String, dynamic>> registerUser({
    required String phoneOrEmail,
    required String name,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

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

    // Create user data
    _currentUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'phone': isEmail ? null : phoneOrEmail,
      'email': isEmail ? phoneOrEmail : null,
      'password': password, // In real app, this would be hashed
      'createdAt': DateTime.now().toIso8601String(),
      'isVerified': false,
    };

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userKey, _currentUser.toString());
    await prefs.setString(_nameKey, name);
    
    if (isEmail) {
      await prefs.setString(_emailKey, phoneOrEmail);
    } else {
      await prefs.setString(_phoneKey, phoneOrEmail);
    }

    return _currentUser!;
  }

  // Login user
  static Future<Map<String, dynamic>> loginUser({
    required String phoneOrEmail,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would validate against a backend
    // For now, we'll check against stored data
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString(_nameKey);
    
    if (storedName == null) {
      throw Exception('User not found. Please register first.');
    }

    // Create user data from stored info
    bool isEmail = phoneOrEmail.contains('@');
    _currentUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': storedName,
      'phone': isEmail ? null : phoneOrEmail,
      'email': isEmail ? phoneOrEmail : null,
      'password': password,
      'createdAt': DateTime.now().toIso8601String(),
      'isVerified': true,
    };

    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userKey, _currentUser.toString());

    return _currentUser!;
  }

  // Send OTP for verification
  static Future<String> sendOTP(String phoneOrEmail) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate random 6-digit OTP
    String otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
    
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
        _currentUser!['isVerified'] = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, _currentUser.toString());
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
    await prefs.remove(_userKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_emailKey);
  }

  // Load user data from storage
  static Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (isLoggedIn) {
      final name = prefs.getString(_nameKey);
      final phone = prefs.getString(_phoneKey);
      final email = prefs.getString(_emailKey);
      
      if (name != null) {
        _currentUser = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': name,
          'phone': phone,
          'email': email,
          'isVerified': true,
        };
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
    if (_currentUser != null) {
      return _currentUser!['name'] ?? 'User';
    }
    return 'Guest';
  }

  // Get user contact info
  static String getUserContact() {
    if (_currentUser != null) {
      return _currentUser!['phone'] ?? _currentUser!['email'] ?? '';
    }
    return '';
  }

  // Check if user is verified
  static bool isUserVerified() {
    return _currentUser?['isVerified'] ?? false;
  }
}