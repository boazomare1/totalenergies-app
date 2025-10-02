import '../services/hive_database_service.dart';

class EnhancedOrderService {
  static final EnhancedOrderService _instance =
      EnhancedOrderService._internal();
  factory EnhancedOrderService() => _instance;
  EnhancedOrderService._internal();

  /// Create a new order and save to Hive
  Future<Map<String, dynamic>> createOrder({
    required String userId,
    required String orderType,
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    required String stationId,
  }) async {
    try {
      final now = DateTime.now();
      final orderId =
          'ORD-${now.millisecondsSinceEpoch.toString().substring(8)}';

      final order = {
        'id': orderId,
        'userId': userId,
        'date':
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'time':
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        'station': stationId,
        'status': 'In Progress',
        'total': _calculateTotal(items),
        'items': items,
        'paymentMethod': paymentMethod,
        'rating': null,
        'trackingInfo': _generateInitialTrackingInfo(now),
      };

      // Save to Hive
      await HiveDatabaseService.saveOrder(order);

      return order;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  /// Get all orders for a user from Hive
  List<Map<String, dynamic>> getUserOrders(String userId) {
    try {
      return HiveDatabaseService.getUserOrders(userId);
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }

  /// Get order by ID from Hive
  Map<String, dynamic>? getOrderById(String orderId) {
    try {
      return HiveDatabaseService.getOrderById(orderId);
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }

  /// Update order status in Hive
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await HiveDatabaseService.updateOrderStatus(orderId, newStatus);
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  /// Delete order from Hive
  Future<void> deleteOrder(String orderId) async {
    try {
      await HiveDatabaseService.deleteOrder(orderId);
    } catch (e) {
      print('Error deleting order: $e');
      rethrow;
    }
  }

  /// Search orders by query
  List<Map<String, dynamic>> searchOrders(String userId, String query) {
    try {
      final userOrders = getUserOrders(userId);
      final searchQuery = query.toLowerCase();

      return userOrders.where((order) {
        return order['id'].toLowerCase().contains(searchQuery) ||
            order['station'].toLowerCase().contains(searchQuery) ||
            order['status'].toLowerCase().contains(searchQuery);
      }).toList();
    } catch (e) {
      print('Error searching orders: $e');
      return [];
    }
  }

  /// Get orders by status
  List<Map<String, dynamic>> getOrdersByStatus(String userId, String status) {
    try {
      final userOrders = getUserOrders(userId);
      return userOrders.where((order) => order['status'] == status).toList();
    } catch (e) {
      print('Error getting orders by status: $e');
      return [];
    }
  }

  /// Get recent orders (last 10)
  List<Map<String, dynamic>> getRecentOrders(String userId, {int limit = 10}) {
    try {
      final userOrders = getUserOrders(userId);
      return userOrders.take(limit).toList();
    } catch (e) {
      print('Error getting recent orders: $e');
      return [];
    }
  }

  /// Get order statistics for user
  Map<String, dynamic> getOrderStatistics(String userId) {
    try {
      final userOrders = getUserOrders(userId);

      final totalOrders = userOrders.length;
      final totalSpent = userOrders.fold(
        0.0,
        (sum, order) => sum + (order['total'] as num).toDouble(),
      );

      final statusCounts = <String, int>{};
      for (final order in userOrders) {
        final status = order['status'] as String;
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }

      return {
        'totalOrders': totalOrders,
        'totalSpent': totalSpent,
        'statusCounts': statusCounts,
        'averageOrderValue': totalOrders > 0 ? totalSpent / totalOrders : 0.0,
      };
    } catch (e) {
      print('Error getting order statistics: $e');
      return {
        'totalOrders': 0,
        'totalSpent': 0.0,
        'statusCounts': {},
        'averageOrderValue': 0.0,
      };
    }
  }

  // Private helper methods

  double _calculateTotal(List<Map<String, dynamic>> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + (item['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> _generateInitialTrackingInfo(DateTime now) {
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return {
      'currentLocation': 'Order confirmed - Processing...',
      'estimatedDelivery': _getEstimatedDelivery(now),
      'lastUpdate': now.toString(),
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
    };
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
