class OrderModel {
  final String id;
  final String date;
  final String time;
  final String station;
  final String status;
  final double total;
  final List<OrderItem> items;
  final String paymentMethod;
  final int? rating;
  final OrderTrackingInfo trackingInfo;

  OrderModel({
    required this.id,
    required this.date,
    required this.time,
    required this.station,
    required this.status,
    required this.total,
    required this.items,
    required this.paymentMethod,
    this.rating,
    required this.trackingInfo,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      station: json['station'] as String,
      status: json['status'] as String,
      total: (json['total'] as num).toDouble(),
      items:
          (json['items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList(),
      paymentMethod: json['paymentMethod'] as String,
      rating: json['rating'] as int?,
      trackingInfo: OrderTrackingInfo.fromJson(
        json['trackingInfo'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'station': station,
      'status': status,
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
      'paymentMethod': paymentMethod,
      'rating': rating,
      'trackingInfo': trackingInfo.toJson(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? date,
    String? time,
    String? station,
    String? status,
    double? total,
    List<OrderItem>? items,
    String? paymentMethod,
    int? rating,
    OrderTrackingInfo? trackingInfo,
  }) {
    return OrderModel(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      station: station ?? this.station,
      status: status ?? this.status,
      total: total ?? this.total,
      items: items ?? this.items,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      rating: rating ?? this.rating,
      trackingInfo: trackingInfo ?? this.trackingInfo,
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final double total;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'price': price, 'total': total};
  }
}

class OrderTrackingInfo {
  final String currentLocation;
  final String? estimatedDelivery;
  final String lastUpdate;
  final List<TrackingStep> trackingSteps;

  OrderTrackingInfo({
    required this.currentLocation,
    this.estimatedDelivery,
    required this.lastUpdate,
    required this.trackingSteps,
  });

  factory OrderTrackingInfo.fromJson(Map<String, dynamic> json) {
    return OrderTrackingInfo(
      currentLocation: json['currentLocation'] as String,
      estimatedDelivery: json['estimatedDelivery'] as String?,
      lastUpdate: json['lastUpdate'] as String,
      trackingSteps:
          (json['trackingSteps'] as List)
              .map((step) => TrackingStep.fromJson(step))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLocation': currentLocation,
      'estimatedDelivery': estimatedDelivery,
      'lastUpdate': lastUpdate,
      'trackingSteps': trackingSteps.map((step) => step.toJson()).toList(),
    };
  }

  OrderTrackingInfo copyWith({
    String? currentLocation,
    String? estimatedDelivery,
    String? lastUpdate,
    List<TrackingStep>? trackingSteps,
  }) {
    return OrderTrackingInfo(
      currentLocation: currentLocation ?? this.currentLocation,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      trackingSteps: trackingSteps ?? this.trackingSteps,
    );
  }
}

class TrackingStep {
  final String step;
  final String time;
  final bool completed;

  TrackingStep({
    required this.step,
    required this.time,
    required this.completed,
  });

  factory TrackingStep.fromJson(Map<String, dynamic> json) {
    return TrackingStep(
      step: json['step'] as String,
      time: json['time'] as String,
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'step': step, 'time': time, 'completed': completed};
  }

  TrackingStep copyWith({String? step, String? time, bool? completed}) {
    return TrackingStep(
      step: step ?? this.step,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }
}

enum OrderStatus {
  confirmed,
  processing,
  preparing,
  ready,
  inProgress,
  completed,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'processing':
        return OrderStatus.processing;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'in progress':
        return OrderStatus.inProgress;
      case 'completed':
        return OrderStatus.completed;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.confirmed;
    }
  }
}
