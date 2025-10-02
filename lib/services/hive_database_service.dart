import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class HiveDatabaseService {
  static const String _usersBoxName = 'users';
  static const String _settingsBoxName = 'settings';
  static const String _biometricBoxName = 'biometric';
  static const String _ordersBoxName = 'orders';
  static const String _cartBoxName = 'cart';

  static Box<UserModel>? _usersBox;
  static Box<dynamic>? _settingsBox;
  static Box<dynamic>? _biometricBox;
  static Box<dynamic>? _ordersBox;
  static Box<dynamic>? _cartBox;

  /// Initialize Hive database
  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      // Register adapters
      Hive.registerAdapter(UserModelAdapter());

      // Open boxes
      _usersBox = await Hive.openBox<UserModel>(_usersBoxName);
      _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);
      _biometricBox = await Hive.openBox<dynamic>(_biometricBoxName);
      _ordersBox = await Hive.openBox<dynamic>(_ordersBoxName);
      _cartBox = await Hive.openBox<dynamic>(_cartBoxName);

      print('Hive database initialized successfully');
    } catch (e) {
      print('Error initializing Hive database: $e');
      rethrow;
    }
  }

  /// Get users box
  static Box<UserModel> get usersBox {
    if (_usersBox == null) {
      throw Exception(
        'Hive database not initialized. Call initialize() first.',
      );
    }
    return _usersBox!;
  }

  /// Get settings box
  static Box<dynamic> get settingsBox {
    if (_settingsBox == null) {
      throw Exception(
        'Hive database not initialized. Call initialize() first.',
      );
    }
    return _settingsBox!;
  }

  /// Get biometric box
  static Box<dynamic> get biometricBox {
    if (_biometricBox == null) {
      throw Exception(
        'Hive database not initialized. Call initialize() first.',
      );
    }
    return _biometricBox!;
  }

  /// Get orders box
  static Box<dynamic> get ordersBox {
    if (_ordersBox == null) {
      throw Exception(
        'Hive database not initialized. Call initialize() first.',
      );
    }
    return _ordersBox!;
  }

  /// Get cart box
  static Box<dynamic> get cartBox {
    if (_cartBox == null) {
      throw Exception(
        'Hive database not initialized. Call initialize() first.',
      );
    }
    return _cartBox!;
  }

  /// User Management Methods

  /// Create a new user
  static Future<UserModel> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Check if user already exists
      if (await userExists(email) || await userExists(phone)) {
        throw Exception('User with this email or phone already exists');
      }

      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        password: password, // In real app, hash this password
        createdAt: DateTime.now(),
      );

      await usersBox.put(user.id, user);
      print('User created successfully: ${user.id}');
      return user;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Get user by email or phone
  static Future<UserModel?> getUserByEmailOrPhone(String identifier) async {
    try {
      for (final user in usersBox.values) {
        if (user.email == identifier || user.phone == identifier) {
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Get user by ID
  static Future<UserModel?> getUserById(String id) async {
    try {
      return usersBox.get(id);
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  /// Check if user exists
  static Future<bool> userExists(String identifier) async {
    try {
      final user = await getUserByEmailOrPhone(identifier);
      return user != null;
    } catch (e) {
      print('Error checking if user exists: $e');
      return false;
    }
  }

  /// Authenticate user
  static Future<UserModel?> authenticateUser({
    required String identifier,
    required String password,
  }) async {
    try {
      final user = await getUserByEmailOrPhone(identifier);
      if (user != null && user.password == password && user.isActive) {
        // Update last login
        user.lastLoginAt = DateTime.now();
        await usersBox.put(user.id, user);
        return user;
      }
      return null;
    } catch (e) {
      print('Error authenticating user: $e');
      return null;
    }
  }

  /// Update user
  static Future<void> updateUser(UserModel user) async {
    try {
      await usersBox.put(user.id, user);
      print('User updated successfully: ${user.id}');
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Delete user
  static Future<void> deleteUser(String userId) async {
    try {
      await usersBox.delete(userId);
      print('User deleted successfully: $userId');
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Get all users (for testing)
  static List<UserModel> getAllUsers() {
    try {
      return usersBox.values.toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  /// Settings Management

  /// Set setting value
  static Future<void> setSetting(String key, dynamic value) async {
    try {
      await settingsBox.put(key, value);
    } catch (e) {
      print('Error setting $key: $e');
    }
  }

  /// Get setting value
  static T? getSetting<T>(String key, {T? defaultValue}) {
    try {
      return settingsBox.get(key, defaultValue: defaultValue) as T?;
    } catch (e) {
      print('Error getting $key: $e');
      return defaultValue;
    }
  }

  /// Biometric Management

  /// Set biometric preference for user
  static Future<void> setBiometricPreference({
    required String userId,
    required bool enabled,
    String? biometricType,
  }) async {
    try {
      final user = await getUserById(userId);
      if (user != null) {
        user.biometricEnabled = enabled;
        user.biometricType = biometricType;
        await updateUser(user);
      }
    } catch (e) {
      print('Error setting biometric preference: $e');
    }
  }

  /// Get biometric preference for user
  static Future<bool> getBiometricPreference(String userId) async {
    try {
      final user = await getUserById(userId);
      return user?.biometricEnabled ?? false;
    } catch (e) {
      print('Error getting biometric preference: $e');
      return false;
    }
  }

  /// Store biometric test data
  static Future<void> storeBiometricTestData({
    required String userId,
    required Map<String, dynamic> testData,
  }) async {
    try {
      await biometricBox.put('${userId}_test_data', testData);
    } catch (e) {
      print('Error storing biometric test data: $e');
    }
  }

  /// Get biometric test data
  static Map<String, dynamic>? getBiometricTestData(String userId) {
    try {
      return biometricBox.get('${userId}_test_data') as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting biometric test data: $e');
      return null;
    }
  }

  /// Order Management Methods

  /// Save order to Hive
  static Future<void> saveOrder(Map<String, dynamic> order) async {
    try {
      await ordersBox.put(order['id'], order);
      print('Order saved successfully: ${order['id']}');
    } catch (e) {
      print('Error saving order: $e');
      rethrow;
    }
  }

  /// Get all orders for a user
  static List<Map<String, dynamic>> getUserOrders(String userId) {
    try {
      final allOrders =
          ordersBox.values
              .cast<Map<String, dynamic>>()
              .where((order) => order['userId'] == userId)
              .toList();

      // Sort by date (newest first)
      allOrders.sort((a, b) => b['date'].compareTo(a['date']));
      return allOrders;
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }

  /// Get order by ID
  static Map<String, dynamic>? getOrderById(String orderId) {
    try {
      return ordersBox.get(orderId) as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }

  /// Update order status
  static Future<void> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    try {
      final order = getOrderById(orderId);
      if (order != null) {
        order['status'] = newStatus;
        await ordersBox.put(orderId, order);
        print('Order status updated: $orderId -> $newStatus');
      }
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  /// Delete order
  static Future<void> deleteOrder(String orderId) async {
    try {
      await ordersBox.delete(orderId);
      print('Order deleted successfully: $orderId');
    } catch (e) {
      print('Error deleting order: $e');
      rethrow;
    }
  }

  /// Cart Management Methods

  /// Add item to cart
  static Future<void> addToCart({
    required String userId,
    required Map<String, dynamic> item,
  }) async {
    try {
      final cartKey = '${userId}_cart';
      List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(
        cartBox.get(cartKey, defaultValue: []) as List,
      );

      // Check if item already exists in cart
      final existingIndex = cart.indexWhere(
        (cartItem) =>
            cartItem['name'] == item['name'] &&
            cartItem['price'] == item['price'],
      );

      if (existingIndex != -1) {
        // Update quantity if item exists
        cart[existingIndex]['quantity'] =
            (cart[existingIndex]['quantity'] as int) +
            (item['quantity'] as int);
        cart[existingIndex]['total'] =
            cart[existingIndex]['quantity'] * cart[existingIndex]['price'];
      } else {
        // Add new item to cart
        cart.add(Map<String, dynamic>.from(item));
      }

      await cartBox.put(cartKey, cart);
      print('Item added to cart for user: $userId');
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  /// Get user's cart
  static List<Map<String, dynamic>> getUserCart(String userId) {
    try {
      final cartKey = '${userId}_cart';
      return List<Map<String, dynamic>>.from(
        cartBox.get(cartKey, defaultValue: []) as List,
      );
    } catch (e) {
      print('Error getting user cart: $e');
      return [];
    }
  }

  /// Update cart item quantity
  static Future<void> updateCartItemQuantity({
    required String userId,
    required int itemIndex,
    required int newQuantity,
  }) async {
    try {
      final cartKey = '${userId}_cart';
      List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(
        cartBox.get(cartKey, defaultValue: []) as List,
      );

      if (itemIndex >= 0 && itemIndex < cart.length) {
        if (newQuantity <= 0) {
          cart.removeAt(itemIndex);
        } else {
          cart[itemIndex]['quantity'] = newQuantity;
          cart[itemIndex]['total'] =
              newQuantity * (cart[itemIndex]['price'] as num).toDouble();
        }

        await cartBox.put(cartKey, cart);
        print('Cart item quantity updated for user: $userId');
      }
    } catch (e) {
      print('Error updating cart item quantity: $e');
      rethrow;
    }
  }

  /// Remove item from cart
  static Future<void> removeFromCart({
    required String userId,
    required int itemIndex,
  }) async {
    try {
      final cartKey = '${userId}_cart';
      List<Map<String, dynamic>> cart = List<Map<String, dynamic>>.from(
        cartBox.get(cartKey, defaultValue: []) as List,
      );

      if (itemIndex >= 0 && itemIndex < cart.length) {
        cart.removeAt(itemIndex);
        await cartBox.put(cartKey, cart);
        print('Item removed from cart for user: $userId');
      }
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  /// Clear user's cart
  static Future<void> clearUserCart(String userId) async {
    try {
      final cartKey = '${userId}_cart';
      await cartBox.put(cartKey, []);
      print('Cart cleared for user: $userId');
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }

  /// Get cart total
  static double getCartTotal(String userId) {
    try {
      final cart = getUserCart(userId);
      return cart.fold(
        0.0,
        (sum, item) => sum + (item['total'] as num).toDouble(),
      );
    } catch (e) {
      print('Error getting cart total: $e');
      return 0.0;
    }
  }

  /// User Balance Management

  /// Update user balance
  static Future<void> updateUserBalance(
    String userId,
    double newBalance,
  ) async {
    try {
      final user = await getUserById(userId);
      if (user != null) {
        user.cardBalance = newBalance;
        await updateUser(user);
        print('User balance updated: $userId -> $newBalance');
      }
    } catch (e) {
      print('Error updating user balance: $e');
      rethrow;
    }
  }

  /// Add to user balance
  static Future<void> addToUserBalance(String userId, double amount) async {
    try {
      final user = await getUserById(userId);
      if (user != null) {
        user.cardBalance += amount;
        await updateUser(user);
        print('Added $amount to user balance: $userId');
      }
    } catch (e) {
      print('Error adding to user balance: $e');
      rethrow;
    }
  }

  /// Deduct from user balance
  static Future<bool> deductFromUserBalance(
    String userId,
    double amount,
  ) async {
    try {
      final user = await getUserById(userId);
      if (user != null && user.cardBalance >= amount) {
        user.cardBalance -= amount;
        await updateUser(user);
        print('Deducted $amount from user balance: $userId');
        return true;
      }
      return false;
    } catch (e) {
      print('Error deducting from user balance: $e');
      return false;
    }
  }

  /// Get user balance
  static Future<double> getUserBalance(String userId) async {
    try {
      final user = await getUserById(userId);
      return user?.cardBalance ?? 0.0;
    } catch (e) {
      print('Error getting user balance: $e');
      return 0.0;
    }
  }

  /// Clear all data (for testing)
  static Future<void> clearAllData() async {
    try {
      await usersBox.clear();
      await settingsBox.clear();
      await biometricBox.clear();
      await ordersBox.clear();
      await cartBox.clear();
      print('All data cleared');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  /// Get database statistics
  static Map<String, int> getDatabaseStats() {
    try {
      return {
        'users': usersBox.length,
        'settings': settingsBox.length,
        'biometric_data': biometricBox.length,
        'orders': ordersBox.length,
        'cart_data': cartBox.length,
      };
    } catch (e) {
      print('Error getting database stats: $e');
      return {};
    }
  }

  /// Close all boxes
  static Future<void> close() async {
    try {
      await _usersBox?.close();
      await _settingsBox?.close();
      await _biometricBox?.close();
      await _ordersBox?.close();
      await _cartBox?.close();
      print('Hive database closed');
    } catch (e) {
      print('Error closing database: $e');
    }
  }
}
