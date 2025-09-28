import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'location_service.dart';
import '../firebase_options.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static String? _fcmToken;

  static String? get fcmToken => _fcmToken;

  /// Initialize Firebase and messaging
  static Future<void> initialize() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request notification permission
      await requestNotificationPermission();

      // Get FCM token
      await getFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      print('Notification service initialized successfully');
    } catch (e) {
      print('Failed to initialize notification service: $e');
    }
  }

  /// Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    try {
      print('Initializing local notifications...');

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      final bool? initialized = await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      print('Local notifications initialized: $initialized');

      // Create notification channel for Android
      await _createNotificationChannel();

      print('Local notifications setup complete');
    } catch (e) {
      print('Error initializing local notifications: $e');
    }
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'totalenergies_channel',
      'TotalEnergies Notifications',
      description:
          'Notifications for TotalEnergies app including promotions and updates',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Handle navigation based on notification payload
  }

  /// Request notification permission
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Get FCM token
  static Future<String?> getFCMToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      print('FCM Token: $_fcmToken');
      return _fcmToken;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  /// Set up message handlers
  static void _setupMessageHandlers() {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.messageId}');
      _handleForegroundMessage(message);
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification tapped: ${message.messageId}');
      _handleNotificationTap(message);
    });

    // Handle notification tap when app is terminated
    _messaging.getInitialMessage().then((RemoteMessage? initialMessage) {
      if (initialMessage != null) {
        print('App opened from terminated state: ${initialMessage.messageId}');
        _handleNotificationTap(initialMessage);
      }
    });
  }

  /// Handle foreground messages
  static void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification or update UI
    print('Foreground message: ${message.notification?.title}');
    print('Foreground message body: ${message.notification?.body}');

    // You can show a snackbar or dialog here
    // For now, we'll just print the message
  }

  /// Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    // Navigate to specific screen based on notification data
    final data = message.data;
    print('Notification data: $data');

    // You can add navigation logic here based on the notification data
    // For example, navigate to promotions screen if it's a promotion notification
  }

  /// Send location-based promotion notification (simulation)
  static Future<void> sendLocationBasedPromotion({
    required String title,
    required String body,
    required Map<String, dynamic> promotion,
  }) async {
    try {
      // Check if user is near the promotion location
      final targetLat = promotion['latitude'] as double?;
      final targetLon = promotion['longitude'] as double?;
      final radius = promotion['radius'] as double? ?? 5.0;

      if (targetLat != null && targetLon != null) {
        final isNearby = LocationService.isNearLocation(
          targetLat,
          targetLon,
          radius,
        );

        if (isNearby) {
          // In a real app, you would send this to your backend
          // which would then send the push notification via FCM
          print('Sending location-based promotion: $title');
          print('Promotion: $promotion');

          // For simulation, we'll just show a local notification
          await _showLocalNotification(title, body, promotion);
        }
      }
    } catch (e) {
      print('Error sending location-based promotion: $e');
    }
  }

  /// Show local notification
  static Future<void> _showLocalNotification(
    String title,
    String body,
    Map<String, dynamic> data,
  ) async {
    try {
      print('Attempting to show local notification...');
      print('Title: $title');
      print('Body: $body');

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'totalenergies_channel',
            'TotalEnergies Notifications',
            channelDescription: 'Notifications for TotalEnergies app',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
            autoCancel: true,
            ongoing: false,
            visibility: NotificationVisibility.public,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      print('Notification details created, calling show...');

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
        payload: data.toString(),
      );

      print('Local Notification sent successfully:');
      print('Title: $title');
      print('Body: $body');
      print('Data: $data');
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  /// Show notification (public method)
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _showLocalNotification(title, body, {
      'payload': payload ?? 'default',
    });
  }

  /// Subscribe to topic for location-based notifications
  static Future<void> subscribeToLocationTopic(String locationId) async {
    try {
      await _messaging.subscribeToTopic('location_$locationId');
      print('Subscribed to location topic: location_$locationId');
    } catch (e) {
      print('Error subscribing to location topic: $e');
    }
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromLocationTopic(String locationId) async {
    try {
      await _messaging.unsubscribeFromTopic('location_$locationId');
      print('Unsubscribed from location topic: location_$locationId');
    } catch (e) {
      print('Error unsubscribing from location topic: $e');
    }
  }

  /// Test notification functionality
  static Future<void> testNotification() async {
    try {
      // Check if local notifications are initialized
      print('Testing local notifications...');

      // Ensure local notifications are initialized
      await _initializeLocalNotifications();

      // Simulate a test notification
      await _showLocalNotification(
        'Test Notification',
        'This is a test notification from TotalEnergies app',
        {'type': 'test', 'timestamp': DateTime.now().millisecondsSinceEpoch},
      );

      print('Test notification sent successfully');
    } catch (e) {
      print('Error sending test notification: $e');
    }
  }
}

/// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling background message: ${message.messageId}');
}
