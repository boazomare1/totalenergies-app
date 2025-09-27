# Biometric Testing Guide

## How to Test Biometric Functionality

### 1. **Check Biometric Information**
- Open the app and go to the "Test" tab (notifications icon)
- Look at the "Biometric Information" section
- It will show:
  - ✅ Available (if biometric is working)
  - ❌ Not Available (if not working)
  - Types of biometrics available (Fingerprint, Face ID, etc.)
  - Detailed status information

### 2. **Test Biometric Authentication**
- In the "Test" tab, tap "Test Biometric Auth" button
- This will trigger the actual biometric authentication
- You should see:
  - Biometric prompt (fingerprint scanner, face ID, etc.)
  - Success/failure message
  - Clear error messages if something goes wrong

### 3. **Test on Login Screen**
- Go to the login screen
- Look for "Sign in with Biometric" button
- **Only shows if biometric is available and enrolled**
- If you don't see it, biometric is not available on your device

### 4. **Console Output**
Check the console for detailed information:
```
Biometric check:
- Can check biometrics: true/false
- Device supported: true/false
- Has enrolled biometrics: true/false
```

### 5. **Different Scenarios**

#### **If Biometric is Available:**
- You'll see the biometric button on login screen
- Test button will work and show biometric prompt
- Information section shows "✅ Available"

#### **If Biometric is NOT Available:**
- No biometric button on login screen
- Test button shows "not available" message
- Information section shows "❌ Not Available" with reasons

### 6. **Common Issues and Solutions**

#### **"Not Available" - Possible Reasons:**
1. **No biometric enrolled**: Set up fingerprint/face ID in device settings
2. **Device not supported**: Some emulators don't support biometric
3. **Permission denied**: Check app permissions
4. **Hardware not available**: Device doesn't have biometric sensor

#### **Testing on Different Platforms:**

**Android:**
- Works on real devices with fingerprint/face unlock
- May not work on emulators
- Requires Android 6.0+ (API 23+)

**iOS:**
- Works on real devices with Touch ID/Face ID
- May not work on simulators
- Requires iOS 8.0+

**Desktop (Linux/Windows/Mac):**
- Limited biometric support
- May show "not available" on desktop

### 7. **What You Should See**

#### **On a Real Phone with Biometric:**
```
Biometric Information:
✅ Available
Types: Fingerprint, Face ID
Count: 2
```

#### **On Desktop/Emulator:**
```
Biometric Information:
❌ Not Available
Can check: false
Device supported: false
Enrolled: false
```

### 8. **Testing Steps**

1. **Run the app** on your target device
2. **Go to Test tab** to see biometric information
3. **Try the test button** to trigger biometric authentication
4. **Check login screen** to see if biometric button appears
5. **Check console output** for detailed debugging information

### 9. **Expected Behavior**

- **Real device with biometric**: Button appears, authentication works
- **Real device without biometric**: Button hidden, clear error messages
- **Emulator/Desktop**: Button hidden, shows "not available"

The app now intelligently shows/hides the biometric option based on actual device capabilities!