import 'dart:async';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  // Simulate order tracking data
  final Map<String, Map<String, dynamic>> _trackingData = {};

  /// Track an order by its ID
  Future<Map<String, dynamic>?> trackOrder(String orderId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if we have tracking data for this order
    if (_trackingData.containsKey(orderId)) {
      return _trackingData[orderId];
    }

    // Generate mock tracking data for unknown orders
    return _generateMockTrackingData(orderId);
  }

  /// Create a new order
  Future<Map<String, dynamic>> createOrder({
    required String orderType,
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    required String stationId,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();
    final orderId = 'ORD-${now.millisecondsSinceEpoch.toString().substring(8)}';

    final order = {
      'id': orderId,
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

    // Store tracking data
    _trackingData[orderId] = order['trackingInfo'] as Map<String, dynamic>;

    return order;
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_trackingData.containsKey(orderId)) {
      final trackingData = _trackingData[orderId]!;
      trackingData['currentLocation'] = _getStatusLocation(newStatus);
      trackingData['lastUpdate'] = DateTime.now().toString();

      // Update tracking steps
      final steps = trackingData['trackingSteps'] as List<Map<String, dynamic>>;
      for (var step in steps) {
        if (step['step'].toString().toLowerCase().contains(
          newStatus.toLowerCase(),
        )) {
          step['completed'] = true;
          break;
        }
      }

      return true;
    }

    return false;
  }

  /// Get order history for a user
  Future<List<Map<String, dynamic>>> getOrderHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Return mock order history
    return [
      {
        'id': 'ORD-001',
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
        'trackingInfo': _generateDeliveredTrackingInfo(),
      },
    ];
  }

  /// Search orders by order ID or station
  Future<List<Map<String, dynamic>>> searchOrders(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // This would typically search through a database
    // For now, return empty list as we're using mock data
    return [];
  }

  /// Refresh tracking information for an order
  Future<Map<String, dynamic>?> refreshTracking(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (_trackingData.containsKey(orderId)) {
      final trackingInfo = _trackingData[orderId]!;

      // Simulate progress in tracking
      final steps = trackingInfo['trackingSteps'] as List<Map<String, dynamic>>;
      final currentStepIndex = steps.indexWhere((step) => !step['completed']);

      if (currentStepIndex != -1 && currentStepIndex < steps.length) {
        steps[currentStepIndex]['completed'] = true;
        trackingInfo['lastUpdate'] = DateTime.now().toString();

        // Update current location
        trackingInfo['currentLocation'] = _getStepLocation(
          steps[currentStepIndex]['step'],
        );
      }

      return trackingInfo;
    }

    return null;
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

  Map<String, dynamic> _generateMockTrackingData(String orderId) {
    final now = DateTime.now();

    return {
      'currentLocation': 'At warehouse - Preparing for dispatch',
      'estimatedDelivery': _getEstimatedDelivery(now),
      'lastUpdate': now.toString(),
      'trackingSteps': [
        {'step': 'Order Confirmed', 'time': '09:00', 'completed': true},
        {'step': 'Processing', 'time': '09:15', 'completed': true},
        {'step': 'Preparing', 'time': '10:15', 'completed': false},
        {'step': 'Ready for Dispatch', 'time': '12:00', 'completed': false},
        {'step': 'Out for Delivery', 'time': '13:30', 'completed': false},
        {'step': 'Delivered', 'time': '14:30', 'completed': false},
      ],
    };
  }

  Map<String, dynamic> _generateDeliveredTrackingInfo() {
    return {
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

  String _getStatusLocation(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Order confirmed - Processing payment...';
      case 'processing':
        return 'Processing payment - Preparing order...';
      case 'preparing':
        return 'Preparing your order...';
      case 'ready':
        return 'Order ready for pickup/delivery';
      case 'in progress':
        return 'Order in progress - Service being provided';
      case 'completed':
      case 'delivered':
        return 'Order completed successfully';
      case 'cancelled':
        return 'Order has been cancelled';
      default:
        return 'Order status updated';
    }
  }

  String _getStepLocation(String stepName) {
    switch (stepName.toLowerCase()) {
      case 'order confirmed':
        return 'Order confirmed - Processing payment...';
      case 'processing payment':
        return 'Processing payment - Validating transaction...';
      case 'preparing order':
        return 'Preparing your order - Gathering items...';
      case 'order ready':
        return 'Order ready for pickup/delivery';
      case 'in progress':
        return 'Service in progress - Your order is being processed';
      case 'completed':
        return 'Order completed successfully';
      default:
        return 'Processing your order...';
    }
  }
}
