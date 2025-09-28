import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  double _totalAmount = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    // Simulate loading cart items
    setState(() {
      _cartItems = [
        {
          'id': '1',
          'name': 'TotalEnergies Quartz 9000 5W-30',
          'price': 45.99,
          'quantity': 2,
          'image': 'assets/images/quartz_oil_bg.png',
          'category': 'Motor Oil',
        },
        {
          'id': '2',
          'name': 'TotalEnergies Coolant Antifreeze',
          'price': 25.50,
          'quantity': 1,
          'image': 'assets/images/quartz_oil_bg.png',
          'category': 'Coolant',
        },
        {
          'id': '3',
          'name': 'TotalEnergies Brake Fluid DOT 4',
          'price': 18.75,
          'quantity': 1,
          'image': 'assets/images/quartz_oil_bg.png',
          'category': 'Brake Fluid',
        },
      ];
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _totalAmount = _cartItems.fold(0.0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(index);
    } else {
      setState(() {
        _cartItems[index]['quantity'] = newQuantity;
        _calculateTotal();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _calculateTotal();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Item removed from cart',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Clear Cart',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _cartItems.clear();
                _totalAmount = 0.0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Cart cleared',
                    style: GoogleFonts.poppins(),
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: Text(
              'Clear',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate checkout process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Order Placed!',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your order has been placed successfully!',
                  style: GoogleFonts.poppins(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Order ID: #${DateTime.now().millisecondsSinceEpoch}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _cartItems.clear();
                    _totalAmount = 0.0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60012),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Continue Shopping',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              onPressed: _clearCart,
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear Cart',
            ),
        ],
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(index);
                    },
                  ),
                ),
                _buildCheckoutSection(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to get started',
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_bag),
            label: Text(
              'Browse Products',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE60012),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final item = _cartItems[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['category'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item['price'].toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE60012),
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity Controls
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _updateQuantity(index, item['quantity'] - 1),
                      icon: const Icon(Icons.remove),
                      iconSize: 20,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item['quantity']}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _updateQuantity(index, item['quantity'] + 1),
                      icon: const Icon(Icons.add),
                      iconSize: 20,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE60012),
                  ),
                ),
              ],
            ),
            
            // Remove Button
            IconButton(
              onPressed: () => _removeItem(index),
              icon: const Icon(Icons.delete_outline),
              color: Colors.red[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total (${_cartItems.length} items)',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${_totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE60012),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Proceed to Checkout',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}