# Notification and Location Testing Guide

## Overview
This document outlines how to test the newly implemented notification and location features in the TotalEnergies app.

## Features Implemented

### 1. Authentication Flow Redesign
- ✅ Separated login and register screens
- ✅ Added biometric/fingerprint login support
- ✅ Added skip login option for public data access
- ✅ Login banner shown when user is not authenticated

### 2. Location Services
- ✅ Location permission requests
- ✅ Current location detection
- ✅ Location-based promotions
- ✅ Distance calculations

### 3. Push Notifications
- ✅ Firebase integration
- ✅ FCM token generation
- ✅ Location-based notification simulation
- ✅ Test notification functionality

### 4. Biometric Authentication
- ✅ Biometric availability checking
- ✅ Fingerprint/Face ID authentication
- ✅ Fallback to password authentication

## Testing Steps

### 1. Test Authentication Flow
1. Launch the app
2. You should see the login screen with:
   - Phone/Email field
   - Password field
   - "Sign in with Biometric" button (if available)
   - "Skip" button in top right
   - "Create Account" link

### 2. Test Skip Login Functionality
1. Tap "Skip" button on login screen
2. You should be taken to the main screen
3. Notice the login banner at the top encouraging sign-in
4. You can still access public features

### 3. Test Biometric Login
1. If biometric is available on your device:
   - Tap "Sign in with Biometric" button
   - Follow the biometric prompt
   - Should authenticate and navigate to main screen

### 4. Test Location Services
1. Navigate to the "Test" tab (notifications icon)
2. Check if current location is displayed
3. If not, the app should request location permission
4. Grant location permission when prompted

### 5. Test Notifications
1. In the "Test" tab, tap "Test Basic Notification"
2. Check console output for notification details
3. Tap "Test Location Notification" to test location-based notifications
4. Tap "Test Location Promotions" to test with your actual location

### 6. Test Registration Flow
1. From login screen, tap "Create Account"
2. Fill in registration form
3. Complete OTP verification (simulated)
4. Should navigate to main screen after successful registration

## Expected Console Output

When testing notifications, you should see output like:
```
FCM Token: [your-fcm-token]
Location: [latitude], [longitude]
Local Notification:
Title: [notification-title]
Body: [notification-body]
Data: [notification-data]
```

## Troubleshooting

### Location Not Working
- Ensure location permissions are granted
- Check if location services are enabled on device
- Verify GPS is turned on

### Biometric Not Working
- Ensure biometric is set up on device
- Check if biometric authentication is available
- Some emulators don't support biometric authentication

### Notifications Not Working
- Check console for FCM token
- Verify Firebase is properly initialized
- Check network connectivity

## Features Summary

1. **Separate Login/Register Screens**: Clean, focused authentication flow
2. **Biometric Authentication**: Secure, convenient login option
3. **Skip Login**: Public access without forcing authentication
4. **Location Services**: Location-based features and promotions
5. **Push Notifications**: Firebase-powered notification system
6. **Test Interface**: Easy testing of all new features

## Next Steps

1. Test all features thoroughly
2. Verify location-based promotions work correctly
3. Test notification delivery
4. Ensure biometric authentication works on real devices
5. Test the complete user flow from registration to main app usage