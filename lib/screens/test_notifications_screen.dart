import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/notification_service.dart';
import '../services/location_service.dart';
import '../services/biometric_service.dart';
import '../services/hive_database_service.dart';

class TestNotificationsScreen extends StatefulWidget {
  const TestNotificationsScreen({super.key});

  @override
  State<TestNotificationsScreen> createState() =>
      _TestNotificationsScreenState();
}

class _TestNotificationsScreenState extends State<TestNotificationsScreen> {
  String? _fcmToken;
  String? _currentLocation;
  Map<String, dynamic>? _biometricInfo;
  Map<String, int>? _databaseStats;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get FCM token
      _fcmToken = await NotificationService.getFCMToken();

      // Get current location
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        _currentLocation =
            '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      }

      // Get biometric information
      _biometricInfo = await BiometricService.getBiometricInfo();

      // Get database statistics
      _databaseStats = HiveDatabaseService.getDatabaseStats();
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Test Notifications',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FCM Token Section
                    _buildSection(
                      title: 'FCM Token',
                      content: _fcmToken ?? 'Not available',
                      icon: Icons.token,
                    ),
                    const SizedBox(height: 20),

                    // Current Location Section
                    _buildSection(
                      title: 'Current Location',
                      content: _currentLocation ?? 'Not available',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 20),

                    // Biometric Information Section
                    _buildBiometricSection(),
                    const SizedBox(height: 20),

                    // Database Information Section
                    _buildDatabaseSection(),
                    const SizedBox(height: 20),

                    // Test Buttons
                    _buildTestButtons(),
                    const SizedBox(height: 20),

                    // Location-based Promotions Test
                    _buildLocationPromotionsTest(),
                  ],
                ),
              ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFE60012)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButtons() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Notifications',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testBasicNotification,
                icon: const Icon(Icons.notifications),
                label: Text(
                  'Test Basic Notification',
                  style: GoogleFonts.poppins(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60012),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testLocationNotification,
                icon: const Icon(Icons.location_on),
                label: Text(
                  'Test Location Notification',
                  style: GoogleFonts.poppins(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _refreshData,
                icon: const Icon(Icons.refresh),
                label: Text('Refresh Data', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testBiometric,
                icon: const Icon(Icons.fingerprint),
                label: Text(
                  'Test Biometric Auth',
                  style: GoogleFonts.poppins(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _createTestUser,
                icon: const Icon(Icons.person_add),
                label: Text('Create Test User', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _clearDatabase,
                icon: const Icon(Icons.delete_forever),
                label: Text('Clear Database', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPromotionsTest() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location-based Promotions Test',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This will test if you receive location-based promotions based on your current location.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _testLocationBasedPromotions,
                icon: const Icon(Icons.local_offer),
                label: Text(
                  'Test Location Promotions',
                  style: GoogleFonts.poppins(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricSection() {
    if (_biometricInfo == null) {
      return _buildSection(
        title: 'Biometric Information',
        content: 'Loading...',
        icon: Icons.fingerprint,
      );
    }

    final isAvailable = _biometricInfo!['isAvailable'] as bool? ?? false;
    final biometricNames =
        _biometricInfo!['biometricNames'] as List<String>? ?? [];
    final canCheckBiometrics =
        _biometricInfo!['canCheckBiometrics'] as bool? ?? false;
    final isDeviceSupported =
        _biometricInfo!['isDeviceSupported'] as bool? ?? false;
    final isEnrolled = _biometricInfo!['isEnrolled'] as bool? ?? false;

    String content = '';
    if (isAvailable) {
      content = '✅ Available\n';
      content += 'Types: ${biometricNames.join(', ')}\n';
      content += 'Count: ${biometricNames.length}';
    } else {
      content = '❌ Not Available\n';
      content += 'Can check: $canCheckBiometrics\n';
      content += 'Device supported: $isDeviceSupported\n';
      content += 'Enrolled: $isEnrolled';
    }

    return _buildSection(
      title: 'Biometric Information',
      content: content,
      icon: isAvailable ? Icons.fingerprint : Icons.fingerprint_outlined,
    );
  }

  Future<void> _testBiometric() async {
    try {
      final isAvailable = await BiometricService.isBiometricAvailable();
      if (!isAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Biometric authentication is not available on this device',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      final result = await BiometricService.authenticateWithBiometric(
        reason: 'Test biometric authentication for TotalEnergies app',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result
                  ? 'Biometric authentication successful! ✅'
                  : 'Biometric authentication failed ❌',
            ),
            backgroundColor: result ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Biometric test error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildDatabaseSection() {
    if (_databaseStats == null) {
      return _buildSection(
        title: 'Database Information',
        content: 'Loading...',
        icon: Icons.storage,
      );
    }

    String content = '';
    content += 'Users: ${_databaseStats!['users'] ?? 0}\n';
    content += 'Settings: ${_databaseStats!['settings'] ?? 0}\n';
    content += 'Biometric Data: ${_databaseStats!['biometric_data'] ?? 0}';

    return _buildSection(
      title: 'Database Information',
      content: content,
      icon: Icons.storage,
    );
  }

  Future<void> _createTestUser() async {
    try {
      final user = await HiveDatabaseService.createUser(
        name: 'Test User ${DateTime.now().millisecondsSinceEpoch}',
        email: 'test${DateTime.now().millisecondsSinceEpoch}@example.com',
        phone: '+254700000000',
        password: 'password123',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test user created: ${user.name}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Refresh data
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating test user: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _clearDatabase() async {
    try {
      await HiveDatabaseService.clearAllData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Database cleared successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Refresh data
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing database: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _testBasicNotification() async {
    try {
      await NotificationService.testNotification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Test notification sent! You should see a notification appear.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _testLocationNotification() async {
    try {
      // Test location-based notification
      await NotificationService.sendLocationBasedPromotion(
        title: 'Nearby Station Alert!',
        body: 'You are near a TotalEnergies station with special offers',
        promotion: {
          'latitude': 37.7749, // Example coordinates
          'longitude': -122.4194,
          'radius': 5.0,
          'station_name': 'Test Station',
          'offer': '20% off on fuel',
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location notification test completed! Check console for details.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testLocationBasedPromotions() async {
    try {
      // Get current location first
      final position = await LocationService.getCurrentLocation();
      if (position == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to get current location. Please check location permissions.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Test with current location
      await NotificationService.sendLocationBasedPromotion(
        title: 'Welcome to TotalEnergies!',
        body: 'You are in our service area. Check out our latest offers!',
        promotion: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'radius': 10.0, // 10km radius
          'station_name': 'Current Location Station',
          'offer': 'Welcome bonus available',
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location-based promotion test completed! Check console for details.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data refreshed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
