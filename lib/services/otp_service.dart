import 'dart:math';

class OTPService {
  static const int _otpLength = 6;
  static const Duration _otpValidityDuration = Duration(minutes: 5);
  
  // Store OTPs temporarily (in real app, this would be server-side)
  static final Map<String, Map<String, dynamic>> _activeOTPs = {};

  // Generate and send OTP
  static Future<String> sendOTP(String phoneNumber, String purpose) async {
    // Generate random 6-digit OTP
    final otp = _generateOTP();
    final expiryTime = DateTime.now().add(_otpValidityDuration);
    
    // Store OTP with metadata
    _activeOTPs[phoneNumber] = {
      'otp': otp,
      'expiry': expiryTime,
      'purpose': purpose,
      'attempts': 0,
      'maxAttempts': 3,
    };

    // Simulate sending OTP via SMS
    print('OTP sent to $phoneNumber: $otp (Valid for 5 minutes)');
    
    // In a real app, this would call an SMS service
    // await _sendSMS(phoneNumber, 'Your TotalEnergies OTP is: $otp. Valid for 5 minutes.');
    
    return otp; // Return for demo purposes
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOTP(String phoneNumber, String enteredOTP) async {
    final otpData = _activeOTPs[phoneNumber];
    
    if (otpData == null) {
      return {
        'success': false,
        'message': 'No OTP found for this phone number',
        'remainingAttempts': 0,
      };
    }

    // Check if OTP has expired
    if (DateTime.now().isAfter(otpData['expiry'])) {
      _activeOTPs.remove(phoneNumber);
      return {
        'success': false,
        'message': 'OTP has expired. Please request a new one.',
        'remainingAttempts': 0,
      };
    }

    // Check attempt limit
    if (otpData['attempts'] >= otpData['maxAttempts']) {
      _activeOTPs.remove(phoneNumber);
      return {
        'success': false,
        'message': 'Maximum attempts exceeded. Please request a new OTP.',
        'remainingAttempts': 0,
      };
    }

    // Increment attempt counter
    otpData['attempts'] = (otpData['attempts'] as int) + 1;

    // Verify OTP
    if (otpData['otp'] == enteredOTP) {
      _activeOTPs.remove(phoneNumber);
      return {
        'success': true,
        'message': 'OTP verified successfully',
        'remainingAttempts': otpData['maxAttempts'] - otpData['attempts'],
      };
    } else {
      final remainingAttempts = otpData['maxAttempts'] - otpData['attempts'];
      return {
        'success': false,
        'message': 'Invalid OTP. $remainingAttempts attempts remaining.',
        'remainingAttempts': remainingAttempts,
      };
    }
  }

  // Check if OTP exists for phone number
  static bool hasActiveOTP(String phoneNumber) {
    final otpData = _activeOTPs[phoneNumber];
    if (otpData == null) return false;
    
    // Check if expired
    if (DateTime.now().isAfter(otpData['expiry'])) {
      _activeOTPs.remove(phoneNumber);
      return false;
    }
    
    return true;
  }

  // Get remaining time for OTP
  static Duration? getRemainingTime(String phoneNumber) {
    final otpData = _activeOTPs[phoneNumber];
    if (otpData == null) return null;
    
    final expiry = otpData['expiry'] as DateTime;
    final now = DateTime.now();
    
    if (now.isAfter(expiry)) {
      _activeOTPs.remove(phoneNumber);
      return null;
    }
    
    return expiry.difference(now);
  }

  // Resend OTP
  static Future<String> resendOTP(String phoneNumber) async {
    // Remove existing OTP
    _activeOTPs.remove(phoneNumber);
    
    // Send new OTP
    return await sendOTP(phoneNumber, 'resend');
  }

  // Clear expired OTPs
  static void clearExpiredOTPs() {
    final now = DateTime.now();
    _activeOTPs.removeWhere((key, value) {
      return now.isAfter(value['expiry']);
    });
  }

  // Generate random OTP
  static String _generateOTP() {
    final random = Random();
    final otp = StringBuffer();
    
    for (int i = 0; i < _otpLength; i++) {
      otp.write(random.nextInt(10));
    }
    
    return otp.toString();
  }

  // Get OTP statistics for debugging
  static Map<String, dynamic> getOTPStats() {
    return {
      'activeOTPs': _activeOTPs.length,
      'otps': _activeOTPs.map((key, value) => MapEntry(key, {
        'purpose': value['purpose'],
        'attempts': value['attempts'],
        'expiry': value['expiry'].toString(),
      })),
    };
  }
}