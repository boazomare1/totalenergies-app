import 'hive_database_service.dart';
import 'user_balance_service.dart';
import 'enhanced_order_service.dart';
import 'enhanced_cart_service.dart';
import 'app_initialization_service.dart';

/// Demo class showing how to integrate the persistent services
/// with the orders screen and other parts of the app
class OrdersIntegrationDemo {
  /// Example: Create a new LPG order with persistence
  static Future<Map<String, dynamic>> createLPGOrderWithPersistence({
    required List<Map<String, dynamic>> lpgItems,
  }) async {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';

      // Create order using enhanced service
      final order = await EnhancedOrderService().createOrder(
        userId: userId,
        orderType: 'LPG Order',
        items: lpgItems,
        paymentMethod: 'TotalEnergies Card',
        stationId: 'TotalEnergies LPG Center',
      );

      // Process payment
      final paymentSuccess = await UserBalanceService().processPayment(
        userId,
        order['total'] as double,
        order['id'] as String,
      );

      if (!paymentSuccess) {
        throw Exception('Payment failed - insufficient balance');
      }

      print('LPG order created and payment processed: ${order['id']}');
      return order;
    } catch (e) {
      print('Error creating LPG order: $e');
      rethrow;
    }
  }

  /// Example: Add items to cart with persistence
  static Future<void> addItemsToCart({
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';

      for (final item in items) {
        await EnhancedCartService().addToCart(
          userId: userId,
          name: item['name'] as String,
          price: item['price'] as double,
          quantity: item['quantity'] as int,
        );
      }

      print('Items added to cart for user: $userId');
    } catch (e) {
      print('Error adding items to cart: $e');
      rethrow;
    }
  }

  /// Example: Get user's orders with persistence
  static List<Map<String, dynamic>> getUserOrdersWithPersistence() {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';
      return EnhancedOrderService().getUserOrders(userId);
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }

  /// Example: Get user's cart with persistence
  static List<Map<String, dynamic>> getUserCartWithPersistence() {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';
      return EnhancedCartService().getCart(userId);
    } catch (e) {
      print('Error getting user cart: $e');
      return [];
    }
  }

  /// Example: Get user's balance with persistence
  static Future<double> getUserBalanceWithPersistence() async {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';
      return await UserBalanceService().getBalance(userId);
    } catch (e) {
      print('Error getting user balance: $e');
      return 0.0;
    }
  }

  /// Example: Create order from cart with persistence
  static Future<Map<String, dynamic>> createOrderFromCartWithPersistence({
    required String station,
    required String paymentMethod,
  }) async {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';

      // Create order from cart
      final order = await EnhancedCartService().createOrderFromCart(
        userId: userId,
        station: station,
        paymentMethod: paymentMethod,
      );

      // Process payment
      final paymentSuccess = await UserBalanceService().processPayment(
        userId,
        order['total'] as double,
        order['id'] as String,
      );

      if (!paymentSuccess) {
        throw Exception('Payment failed - insufficient balance');
      }

      print('Order created from cart and payment processed: ${order['id']}');
      return order;
    } catch (e) {
      print('Error creating order from cart: $e');
      rethrow;
    }
  }

  /// Example: Search orders with persistence
  static List<Map<String, dynamic>> searchOrdersWithPersistence(String query) {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';
      return EnhancedOrderService().searchOrders(userId, query);
    } catch (e) {
      print('Error searching orders: $e');
      return [];
    }
  }

  /// Example: Get order statistics with persistence
  static Map<String, dynamic> getOrderStatisticsWithPersistence() {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';
      return EnhancedOrderService().getOrderStatistics(userId);
    } catch (e) {
      print('Error getting order statistics: $e');
      return {};
    }
  }

  /// Example: Add funds to user balance
  static Future<void> addFundsToUserBalance(double amount) async {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';
      await UserBalanceService().addFunds(userId, amount);
      print('Added $amount to user balance');
    } catch (e) {
      print('Error adding funds: $e');
      rethrow;
    }
  }

  /// Example: Get comprehensive user data
  static Future<Map<String, dynamic>> getUserDataWithPersistence() async {
    try {
      final userId = AppInitializationService.getCurrentUserId() ?? 'demo_user';

      return {
        'userId': userId,
        'balance': await UserBalanceService().getBalance(userId),
        'orders': EnhancedOrderService().getUserOrders(userId),
        'cart': EnhancedCartService().getCart(userId),
        'cartTotal': EnhancedCartService().getCartTotal(userId),
        'orderStatistics': EnhancedOrderService().getOrderStatistics(userId),
        'balanceSummary': await UserBalanceService().getBalanceSummary(userId),
      };
    } catch (e) {
      print('Error getting user data: $e');
      return {};
    }
  }
}
