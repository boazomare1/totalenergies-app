import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0.0;

  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);
  double get totalAmount => _totalAmount;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));

  void addToCart(Map<String, dynamic> product) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item['id'] == product['id'],
    );

    if (existingItemIndex != -1) {
      // Update quantity if item already exists
      _cartItems[existingItemIndex]['quantity'] = 
          (_cartItems[existingItemIndex]['quantity'] as int) + 1;
    } else {
      // Add new item to cart
      _cartItems.add({
        ...product,
        'quantity': 1,
      });
    }

    _calculateTotal();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item['id'] == productId);
    _calculateTotal();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final itemIndex = _cartItems.indexWhere((item) => item['id'] == productId);
    if (itemIndex != -1) {
      _cartItems[itemIndex]['quantity'] = quantity;
      _calculateTotal();
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _totalAmount = 0.0;
    notifyListeners();
  }

  void _calculateTotal() {
    _totalAmount = _cartItems.fold(0.0, (sum, item) {
      return sum + ((item['price'] as double) * (item['quantity'] as int));
    });
  }

  bool isInCart(String productId) {
    return _cartItems.any((item) => item['id'] == productId);
  }

  int getQuantity(String productId) {
    final item = _cartItems.firstWhere(
      (item) => item['id'] == productId,
      orElse: () => {'quantity': 0},
    );
    return item['quantity'] as int;
  }
}