import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodOrderScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const FoodOrderScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<FoodOrderScreen> createState() => _FoodOrderScreenState();
}

class _FoodOrderScreenState extends State<FoodOrderScreen> {
  List<Map<String, dynamic>> _cart = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  void _loadMenu() {
    // This would typically load from an API
    // For now, we'll use static data based on restaurant
  }

  List<Map<String, dynamic>> _getMenuItems() {
    final restaurantName = widget.restaurant['name'] as String;
    
    switch (restaurantName) {
      case 'KFC':
        return [
          {
            'id': 'KFC-001',
            'name': 'Original Recipe Chicken (2 pieces)',
            'description': 'Crispy fried chicken with our secret 11 herbs and spices',
            'price': 450.0,
            'category': 'Chicken',
            'image': 'assets/images/banner_kfc_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'KFC-002',
            'name': 'Zinger Burger',
            'description': 'Spicy chicken fillet with lettuce and mayo',
            'price': 380.0,
            'category': 'Burgers',
            'image': 'assets/images/banner_kfc_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'KFC-003',
            'name': 'Chicken Strips (6 pieces)',
            'description': 'Tender chicken strips with your choice of dipping sauce',
            'price': 320.0,
            'category': 'Chicken',
            'image': 'assets/images/banner_kfc_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'KFC-004',
            'name': 'Colonel\'s Popcorn Chicken',
            'description': 'Bite-sized pieces of our famous chicken',
            'price': 280.0,
            'category': 'Chicken',
            'image': 'assets/images/banner_kfc_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'KFC-005',
            'name': 'KFC Rice Bowl',
            'description': 'Steamed rice with chicken pieces and vegetables',
            'price': 350.0,
            'category': 'Rice Bowls',
            'image': 'assets/images/banner_kfc_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'KFC-006',
            'name': 'French Fries (Large)',
            'description': 'Crispy golden fries seasoned to perfection',
            'price': 180.0,
            'category': 'Sides',
            'image': 'assets/images/banner_kfc_bg.png',
            'isAvailable': true,
          },
        ];
      
      case 'Mugg & Bean':
        return [
          {
            'id': 'MUGG-001',
            'name': 'Full English Breakfast',
            'description': 'Eggs, bacon, sausage, beans, toast, and coffee',
            'price': 650.0,
            'category': 'Breakfast',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'MUGG-002',
            'name': 'Cappuccino',
            'description': 'Rich espresso with steamed milk and foam',
            'price': 180.0,
            'category': 'Coffee',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'MUGG-003',
            'name': 'Chicken Caesar Salad',
            'description': 'Fresh lettuce, grilled chicken, parmesan, and croutons',
            'price': 420.0,
            'category': 'Salads',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'MUGG-004',
            'name': 'Beef Burger',
            'description': 'Juicy beef patty with cheese, lettuce, and tomato',
            'price': 480.0,
            'category': 'Burgers',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'MUGG-005',
            'name': 'Chocolate Muffin',
            'description': 'Freshly baked chocolate muffin with coffee',
            'price': 120.0,
            'category': 'Pastries',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
        ];

      case 'Subway':
        return [
          {
            'id': 'SUB-001',
            'name': 'Italian BMT',
            'description': 'Salami, pepperoni, and ham with your choice of veggies',
            'price': 380.0,
            'category': 'Sandwiches',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'SUB-002',
            'name': 'Chicken Teriyaki',
            'description': 'Grilled chicken with teriyaki sauce and vegetables',
            'price': 420.0,
            'category': 'Sandwiches',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'SUB-003',
            'name': 'Veggie Delite',
            'description': 'Fresh vegetables with your choice of bread and sauce',
            'price': 320.0,
            'category': 'Vegetarian',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'SUB-004',
            'name': 'Tuna Sub',
            'description': 'Tuna salad with lettuce, tomatoes, and onions',
            'price': 360.0,
            'category': 'Sandwiches',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'SUB-005',
            'name': 'Cookies (3 pieces)',
            'description': 'Freshly baked chocolate chip cookies',
            'price': 150.0,
            'category': 'Desserts',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
        ];

      case 'Pizza Inn':
        return [
          {
            'id': 'PIZZA-001',
            'name': 'Margherita Pizza (12")',
            'description': 'Classic tomato sauce, mozzarella, and fresh basil',
            'price': 850.0,
            'category': 'Pizza',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'PIZZA-002',
            'name': 'Pepperoni Pizza (12")',
            'description': 'Tomato sauce, mozzarella, and pepperoni',
            'price': 950.0,
            'category': 'Pizza',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'PIZZA-003',
            'name': 'Chicken BBQ Pizza (12")',
            'description': 'BBQ sauce, grilled chicken, onions, and mozzarella',
            'price': 1050.0,
            'category': 'Pizza',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'PIZZA-004',
            'name': 'Garlic Bread',
            'description': 'Fresh bread with garlic butter and herbs',
            'price': 180.0,
            'category': 'Sides',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'PIZZA-005',
            'name': 'Caesar Salad',
            'description': 'Fresh lettuce, croutons, parmesan, and caesar dressing',
            'price': 320.0,
            'category': 'Salads',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
        ];

      case 'Burger King':
        return [
          {
            'id': 'BK-001',
            'name': 'Whopper',
            'description': 'Flame-grilled beef patty with lettuce, tomato, and mayo',
            'price': 450.0,
            'category': 'Burgers',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'BK-002',
            'name': 'Chicken Royale',
            'description': 'Crispy chicken fillet with lettuce and mayo',
            'price': 380.0,
            'category': 'Burgers',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'BK-003',
            'name': 'Chicken Nuggets (10 pieces)',
            'description': 'Crispy chicken nuggets with your choice of sauce',
            'price': 320.0,
            'category': 'Chicken',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'BK-004',
            'name': 'Onion Rings',
            'description': 'Crispy golden onion rings',
            'price': 200.0,
            'category': 'Sides',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'BK-005',
            'name': 'Chocolate Sundae',
            'description': 'Vanilla ice cream with chocolate sauce',
            'price': 150.0,
            'category': 'Desserts',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
        ];

      case 'Java House':
        return [
          {
            'id': 'JAVA-001',
            'name': 'Americano',
            'description': 'Rich espresso with hot water',
            'price': 120.0,
            'category': 'Coffee',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'JAVA-002',
            'name': 'Latte',
            'description': 'Espresso with steamed milk and foam art',
            'price': 180.0,
            'category': 'Coffee',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'JAVA-003',
            'name': 'Chicken Wrap',
            'description': 'Grilled chicken with vegetables in a tortilla',
            'price': 350.0,
            'category': 'Wraps',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'JAVA-004',
            'name': 'Chocolate Croissant',
            'description': 'Buttery croissant filled with chocolate',
            'price': 200.0,
            'category': 'Pastries',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
          {
            'id': 'JAVA-005',
            'name': 'Fruit Smoothie',
            'description': 'Fresh fruit blended with yogurt',
            'price': 250.0,
            'category': 'Beverages',
            'image': 'assets/images/banner_enjoy_bg.png',
            'isAvailable': true,
          },
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = _getMenuItems();
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Order from ${widget.restaurant['name']}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        actions: [
          if (_cart.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: _showCart,
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cart.length}',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Restaurant Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFE60012),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.restaurant['station'] as String,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.restaurant['address'] as String,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.restaurant['deliveryTime']} • ${widget.restaurant['priceRange']}',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return _buildMenuItemCard(item);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_cart.length} items',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'KSh ${_totalAmount.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE60012),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _proceedToCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE60012),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Checkout',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildMenuItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Item Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.restaurant,
                      color: Colors.grey,
                      size: 30,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'KSh ${item['price'].toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE60012),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE60012).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['category'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFE60012),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add to Cart Button
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _addToCart(item),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
                minimumSize: const Size(40, 40),
              ),
              child: const Icon(Icons.add, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      _cart.add(item);
      _totalAmount += item['price'] as double;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item['name']} added to cart',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Order (${_cart.length} items)',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
            // Cart Items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  final item = _cart[index];
                  return _buildCartItem(item, index);
                },
              ),
            ),
            // Total and Checkout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'KSh ${_totalAmount.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
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
                      onPressed: _proceedToCheckout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60012),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Proceed to Checkout',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'KSh ${item['price'].toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFE60012),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeFromCart(index),
            icon: const Icon(Icons.remove_circle, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      _totalAmount -= _cart[index]['price'] as double;
      _cart.removeAt(index);
    });
  }

  void _proceedToCheckout() {
    Navigator.pop(context); // Close cart if open
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Order Confirmation',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant: ${widget.restaurant['name']}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Items: ${_cart.length}',
              style: GoogleFonts.poppins(),
            ),
            Text(
              'Total: KSh ${_totalAmount.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Text(
              'Your order will be prepared at ${widget.restaurant['station']}. Please collect it in ${widget.restaurant['deliveryTime']}.',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmOrder();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE60012),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }

  void _confirmOrder() {
    setState(() {
      _cart.clear();
      _totalAmount = 0.0;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order confirmed! You will receive a notification when ready.',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}