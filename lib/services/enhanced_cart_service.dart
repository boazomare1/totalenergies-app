import '../services/hive_database_service.dart';

class EnhancedCartService {
  static final EnhancedCartService _instance = EnhancedCartService._internal();
  factory EnhancedCartService() => _instance;
  EnhancedCartService._internal();

  /// Add item to cart with persistence
  Future<void> addToCart({
    required String userId,
    required String name,
    required double price,
    required int quantity,
  }) async {
    try {
      final item = {
        'name': name,
        'price': price,
        'quantity': quantity,
        'total': price * quantity,
        'addedAt': DateTime.now().toIso8601String(),
      };

      await HiveDatabaseService.addToCart(userId: userId, item: item);
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  /// Get user's cart
  List<Map<String, dynamic>> getCart(String userId) {
    try {
      return HiveDatabaseService.getUserCart(userId);
    } catch (e) {
      print('Error getting cart: $e');
      return [];
    }
  }

  /// Update item quantity in cart
  Future<void> updateItemQuantity({
    required String userId,
    required int itemIndex,
    required int newQuantity,
  }) async {
    try {
      await HiveDatabaseService.updateCartItemQuantity(
        userId: userId,
        itemIndex: itemIndex,
        newQuantity: newQuantity,
      );
    } catch (e) {
      print('Error updating cart item quantity: $e');
      rethrow;
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart({
    required String userId,
    required int itemIndex,
  }) async {
    try {
      await HiveDatabaseService.removeFromCart(
        userId: userId,
        itemIndex: itemIndex,
      );
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  /// Clear user's cart
  Future<void> clearCart(String userId) async {
    try {
      await HiveDatabaseService.clearUserCart(userId);
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }

  /// Get cart total
  double getCartTotal(String userId) {
    try {
      return HiveDatabaseService.getCartTotal(userId);
    } catch (e) {
      print('Error getting cart total: $e');
      return 0.0;
    }
  }

  /// Get cart item count
  int getCartItemCount(String userId) {
    try {
      final cart = getCart(userId);
      return cart.fold(0, (sum, item) => sum + (item['quantity'] as int));
    } catch (e) {
      print('Error getting cart item count: $e');
      return 0;
    }
  }

  /// Check if cart is empty
  bool isCartEmpty(String userId) {
    return getCart(userId).isEmpty;
  }

  /// Create order from cart items
  Future<Map<String, dynamic>> createOrderFromCart({
    required String userId,
    required String station,
    required String paymentMethod,
  }) async {
    try {
      final cart = getCart(userId);
      if (cart.isEmpty) {
        throw Exception('Cart is empty');
      }

      final now = DateTime.now();
      final orderId =
          'ORD-${now.millisecondsSinceEpoch.toString().substring(8)}';
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final timeStr =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final total = getCartTotal(userId);

      final order = {
        'id': orderId,
        'userId': userId,
        'date': dateStr,
        'time': timeStr,
        'station': station,
        'status': 'In Progress',
        'total': total,
        'items': List<Map<String, dynamic>>.from(cart),
        'paymentMethod': paymentMethod,
        'rating': null,
        'trackingInfo': {
          'currentLocation': 'Order confirmed - Processing...',
          'estimatedDelivery': _getEstimatedDelivery(now),
          'lastUpdate': '$dateStr $timeStr',
          'trackingSteps': [
            {'step': 'Order Confirmed', 'time': timeStr, 'completed': true},
            {
              'step': 'Processing Payment',
              'time': _getNextTime(now, 2),
              'completed': false,
            },
            {
              'step': 'Preparing Order',
              'time': _getNextTime(now, 5),
              'completed': false,
            },
            {
              'step': 'Order Ready',
              'time': _getNextTime(now, 15),
              'completed': false,
            },
            {
              'step': 'In Progress',
              'time': _getNextTime(now, 20),
              'completed': false,
            },
            {
              'step': 'Completed',
              'time': _getNextTime(now, 30),
              'completed': false,
            },
          ],
        },
      };

      // Save order to Hive
      await HiveDatabaseService.saveOrder(order);

      // Clear cart after successful order creation
      await clearCart(userId);

      return order;
    } catch (e) {
      print('Error creating order from cart: $e');
      rethrow;
    }
  }

  String _getEstimatedDelivery(DateTime now) {
    final estimated = now.add(const Duration(minutes: 30));
    return '${estimated.year}-${estimated.month.toString().padLeft(2, '0')}-${estimated.day.toString().padLeft(2, '0')} ${estimated.hour.toString().padLeft(2, '0')}:${estimated.minute.toString().padLeft(2, '0')}';
  }

  String _getNextTime(DateTime now, int minutes) {
    final next = now.add(Duration(minutes: minutes));
    return '${next.hour.toString().padLeft(2, '0')}:${next.minute.toString().padLeft(2, '0')}';
  }
}
