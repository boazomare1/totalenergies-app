import 'hive_database_service.dart';
import 'user_balance_service.dart';

class AppInitializationService {
  static bool _isInitialized = false;

  /// Initialize the app with persistent data
  static Future<void> initializeApp() async {
    if (_isInitialized) return;

    try {
      print('Initializing app services...');

      // Initialize Hive database
      await HiveDatabaseService.initialize();

      // Initialize demo user if not exists
      await _initializeDemoUser();

      // Initialize demo data
      await _initializeDemoData();

      _isInitialized = true;
      print('App initialization completed successfully');
    } catch (e) {
      print('Error initializing app: $e');
      rethrow;
    }
  }

  /// Initialize demo user with some balance
  static Future<void> _initializeDemoUser() async {
    try {
      const demoUserId = 'demo_user';

      // Check if demo user exists
      final existingUser = await HiveDatabaseService.getUserById(demoUserId);

      if (existingUser == null) {
        // Create demo user
        await HiveDatabaseService.createUser(
          name: 'Demo User',
          email: 'demo@totalenergies.com',
          phone: '+254700000000',
          password: 'demo123',
        );

        // Set current user ID
        await HiveDatabaseService.setSetting('current_user_id', demoUserId);

        // Add some initial balance
        await UserBalanceService().setBalance(demoUserId, 50000.0);

        print('Demo user created with initial balance');
      } else {
        // Set current user ID
        await HiveDatabaseService.setSetting('current_user_id', demoUserId);
        print('Demo user already exists');
      }
    } catch (e) {
      print('Error initializing demo user: $e');
    }
  }

  /// Initialize demo orders and cart data
  static Future<void> _initializeDemoData() async {
    try {
      const demoUserId = 'demo_user';

      // Check if orders already exist
      final existingOrders = HiveDatabaseService.getUserOrders(demoUserId);

      if (existingOrders.isEmpty) {
        // Create some demo orders
        await _createDemoOrders(demoUserId);
        print('Demo orders created');
      } else {
        print('Demo orders already exist');
      }
    } catch (e) {
      print('Error initializing demo data: $e');
    }
  }

  /// Create demo orders
  static Future<void> _createDemoOrders(String userId) async {
    final demoOrders = [
      {
        'id': 'ORD-001',
        'userId': userId,
        'date': '2024-01-15',
        'time': '14:30',
        'station': 'TotalEnergies Westlands',
        'status': 'Delivered',
        'total': 2450.00,
        'items': [
          {'name': 'Petrol', 'quantity': 10, 'price': 180.50, 'total': 1805.00},
          {'name': 'Car Wash', 'quantity': 1, 'price': 500.00, 'total': 500.00},
          {
            'name': 'Air Freshener',
            'quantity': 2,
            'price': 72.50,
            'total': 145.00,
          },
        ],
        'paymentMethod': 'TotalEnergies Card',
        'rating': 5,
        'trackingInfo': {
          'currentLocation': 'Delivered to customer',
          'estimatedDelivery': null,
          'lastUpdate': '2024-01-15 16:45',
          'trackingSteps': [
            {'step': 'Order Confirmed', 'time': '14:30', 'completed': true},
            {'step': 'Preparing Order', 'time': '14:35', 'completed': true},
            {'step': 'Order Ready', 'time': '15:15', 'completed': true},
            {'step': 'Out for Delivery', 'time': '15:30', 'completed': true},
            {'step': 'Delivered', 'time': '16:45', 'completed': true},
          ],
        },
      },
      {
        'id': 'ORD-002',
        'userId': userId,
        'date': '2024-01-12',
        'time': '09:15',
        'station': 'TotalEnergies Karen',
        'status': 'In Progress',
        'total': 1200.00,
        'items': [
          {'name': 'Diesel', 'quantity': 5, 'price': 175.00, 'total': 875.00},
          {
            'name': 'Oil Change',
            'quantity': 1,
            'price': 325.00,
            'total': 325.00,
          },
        ],
        'paymentMethod': 'Mobile Money',
        'rating': null,
        'trackingInfo': {
          'currentLocation': 'At service bay - Oil change in progress',
          'estimatedDelivery': '2024-01-12 11:30',
          'lastUpdate': '2024-01-12 10:15',
          'trackingSteps': [
            {'step': 'Order Confirmed', 'time': '09:15', 'completed': true},
            {'step': 'Vehicle Inspection', 'time': '09:25', 'completed': true},
            {'step': 'Fuel Service', 'time': '09:45', 'completed': true},
            {'step': 'Oil Change', 'time': '10:15', 'completed': false},
            {'step': 'Quality Check', 'time': '11:00', 'completed': false},
            {'step': 'Ready for Pickup', 'time': '11:30', 'completed': false},
          ],
        },
      },
    ];

    // Save demo orders
    for (final order in demoOrders) {
      await HiveDatabaseService.saveOrder(order);
    }
  }

  /// Get current user ID
  static String? getCurrentUserId() {
    try {
      return HiveDatabaseService.getSetting<String>('current_user_id');
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  /// Set current user ID
  static Future<void> setCurrentUserId(String userId) async {
    try {
      await HiveDatabaseService.setSetting('current_user_id', userId);
    } catch (e) {
      print('Error setting current user ID: $e');
      rethrow;
    }
  }

  /// Logout user (clear current user ID)
  static Future<void> logout() async {
    try {
      await HiveDatabaseService.setSetting('current_user_id', null);
      print('User logged out');
    } catch (e) {
      print('Error during logout: $e');
      rethrow;
    }
  }

  /// Get app statistics
  static Map<String, dynamic> getAppStatistics() {
    try {
      final dbStats = HiveDatabaseService.getDatabaseStats();
      final currentUserId = getCurrentUserId();

      Map<String, dynamic> stats = {
        'database': dbStats,
        'currentUser': currentUserId,
        'isInitialized': _isInitialized,
      };

      if (currentUserId != null) {
        // Add user-specific stats
        final userOrders = HiveDatabaseService.getUserOrders(currentUserId);
        final userCart = HiveDatabaseService.getUserCart(currentUserId);

        stats['userOrders'] = userOrders.length;
        stats['userCartItems'] = userCart.length;
        stats['userCartTotal'] = HiveDatabaseService.getCartTotal(
          currentUserId,
        );
      }

      return stats;
    } catch (e) {
      print('Error getting app statistics: $e');
      return {
        'database': {},
        'currentUser': null,
        'isInitialized': _isInitialized,
      };
    }
  }

  /// Clear all app data (for testing)
  static Future<void> clearAllData() async {
    try {
      await HiveDatabaseService.clearAllData();
      _isInitialized = false;
      print('All app data cleared');
    } catch (e) {
      print('Error clearing app data: $e');
      rethrow;
    }
  }
}
