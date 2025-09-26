import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkout_screen.dart';

class GasProductsScreen extends StatefulWidget {
  const GasProductsScreen({super.key});

  @override
  State<GasProductsScreen> createState() => _GasProductsScreenState();
}

class _GasProductsScreenState extends State<GasProductsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _cartItemCount = 0;
  final List<Map<String, dynamic>> _cartItems = [];
  double _cartTotal = 0.0;

  final List<Map<String, dynamic>> _cylinders = [
    {
      'id': 'CYL-001',
      'name': '6KG Refill',
      'description': '6KG Gas Cylinder Refill',
      'price': 1390.00,
      'image': 'assets/images/gas_cylinder_6kg.png',
      'type': 'Refill',
      'weight': '6KG',
      'inStock': true,
      'deliveryTime': 'Same day delivery available',
    },
    {
      'id': 'CYL-002',
      'name': '6KG Refill + Cylinder',
      'description': '6KG Gas Cylinder with New Cylinder',
      'price': 3190.00,
      'image': 'assets/images/gas_cylinder_6kg_new.png',
      'type': 'Complete',
      'weight': '6KG',
      'inStock': true,
      'deliveryTime': 'Same day delivery available',
    },
    {
      'id': 'CYL-003',
      'name': '13KG Refill',
      'description': '13KG Gas Cylinder Refill',
      'price': 3140.00,
      'image': 'assets/images/gas_cylinder_13kg.png',
      'type': 'Refill',
      'weight': '13KG',
      'inStock': true,
      'deliveryTime': 'Same day delivery available',
    },
    {
      'id': 'CYL-004',
      'name': '13KG Refill + Cylinder',
      'description': '13KG Gas Cylinder with New Cylinder',
      'price': 6940.00,
      'image': 'assets/images/gas_cylinder_13kg_new.png',
      'type': 'Complete',
      'weight': '13KG',
      'inStock': true,
      'deliveryTime': 'Same day delivery available',
    },
    {
      'id': 'CYL-005',
      'name': '50KG Refill',
      'description': '50KG Industrial Gas Cylinder Refill',
      'price': 12500.00,
      'image': 'assets/images/gas_cylinder_50kg.png',
      'type': 'Refill',
      'weight': '50KG',
      'inStock': true,
      'deliveryTime': 'Next day delivery',
    },
  ];

  final List<Map<String, dynamic>> _accessories = [
    {
      'id': 'ACC-001',
      'name': '6KG Regulator',
      'description': 'High Pressure Gas Regulator for 6KG Cylinders',
      'price': 825.00,
      'image': 'assets/images/regulator_6kg.png',
      'category': 'Regulators',
      'inStock': true,
      'compatibility': '6KG Cylinders',
    },
    {
      'id': 'ACC-002',
      'name': '13KG Regulator',
      'description': 'High Pressure Gas Regulator for 13KG Cylinders',
      'price': 750.00,
      'image': 'assets/images/regulator_13kg.png',
      'category': 'Regulators',
      'inStock': true,
      'compatibility': '13KG Cylinders',
    },
    {
      'id': 'ACC-003',
      'name': 'Gas Burner',
      'description': 'Single Burner Gas Stove',
      'price': 830.00,
      'image': 'assets/images/gas_burner.png',
      'category': 'Burners',
      'inStock': true,
      'compatibility': 'All Cylinders',
    },
    {
      'id': 'ACC-004',
      'name': 'Gas Grill',
      'description': 'Portable Gas Grill for Outdoor Cooking',
      'price': 320.00,
      'image': 'assets/images/gas_grill.png',
      'category': 'Grills',
      'inStock': true,
      'compatibility': 'All Cylinders',
    },
    {
      'id': 'ACC-005',
      'name': 'Hosepipe 1.5M',
      'description': 'Gas Hose Pipe 1.5 Meters',
      'price': 605.00,
      'image': 'assets/images/hosepipe_1_5m.png',
      'category': 'Hoses',
      'inStock': true,
      'compatibility': 'All Cylinders',
    },
    {
      'id': 'ACC-006',
      'name': 'Hosepipe 2M',
      'description': 'Gas Hose Pipe 2 Meters',
      'price': 810.00,
      'image': 'assets/images/hosepipe_2m.png',
      'category': 'Hoses',
      'inStock': true,
      'compatibility': 'All Cylinders',
    },
    {
      'id': 'ACC-007',
      'name': 'Hosepipe 3M',
      'description': 'Gas Hose Pipe 3 Meters',
      'price': 1200.00,
      'image': 'assets/images/hosepipe_3m.png',
      'category': 'Hoses',
      'inStock': true,
      'compatibility': 'All Cylinders',
    },
    {
      'id': 'ACC-008',
      'name': 'Gas Leak Detector',
      'description': 'Digital Gas Leak Detection Device',
      'price': 2500.00,
      'image': 'assets/images/gas_detector.png',
      'category': 'Safety',
      'inStock': true,
      'compatibility': 'All Cylinders',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'TotalEnergies Gas',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: _viewCart,
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Cylinders'),
            Tab(text: 'Accessories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCylindersTab(),
          _buildAccessoriesTab(),
        ],
      ),
    );
  }

  Widget _buildCylindersTab() {
    return Column(
      children: [
        // Delivery Info
        Container(
          width: double.infinity,
          color: Colors.blue[50],
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Home delivery available between 7.00am and 8.00pm',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Cylinders Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _cylinders.length,
            itemBuilder: (context, index) {
              final cylinder = _cylinders[index];
              return _buildCylinderCard(cylinder);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAccessoriesTab() {
    return Column(
      children: [
        // Delivery Info
        Container(
          width: double.infinity,
          color: Colors.blue[50],
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Home delivery available between 7.00am and 8.00pm',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Accessories Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _accessories.length,
            itemBuilder: (context, index) {
              final accessory = _accessories[index];
              return _buildAccessoryCard(accessory);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCylinderCard(Map<String, dynamic> cylinder) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.local_gas_station,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  if (cylinder['type'] == 'Complete')
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'NEW',
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cylinder['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'KES ${cylinder['price'].toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE60012),
                    ),
                  ),
                  const Spacer(),
                  
                  // Action Buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _addToCart(cylinder),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE60012),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'Add to cart',
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _buyNow(cylinder),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE60012),
                            side: const BorderSide(color: Color(0xFFE60012)),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'Buy Now',
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessoryCard(Map<String, dynamic> accessory) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  _getAccessoryIcon(accessory['category']),
                  size: 50,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          
          // Product Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accessory['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'KES ${accessory['price'].toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE60012),
                    ),
                  ),
                  const Spacer(),
                  
                  // Action Buttons
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _addToCart(accessory),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE60012),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'Add to cart',
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _buyNow(accessory),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE60012),
                            side: const BorderSide(color: Color(0xFFE60012)),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'Buy Now',
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAccessoryIcon(String category) {
    switch (category) {
      case 'Regulators':
        return Icons.settings;
      case 'Burners':
        return Icons.local_fire_department;
      case 'Grills':
        return Icons.outdoor_grill;
      case 'Hoses':
        return Icons.cable;
      case 'Safety':
        return Icons.security;
      default:
        return Icons.category;
    }
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItemCount++;
      _cartItems.add(Map<String, dynamic>.from(product)); // Create a copy
      _cartTotal += product['price'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${product['name']} added to cart',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: _viewCart,
        ),
      ),
    );
  }

  void _buyNow(Map<String, dynamic> product) {
    // Navigate to checkout with single item
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          cartItems: [Map<String, dynamic>.from(product)],
          totalAmount: product['price'],
        ),
      ),
    );
  }

  void _viewCart() {
    if (_cartItemCount == 0) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.4,
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
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Shopping Cart',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              
              // Empty Cart
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add some products to get started',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Navigate to checkout with cart items
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            cartItems: List<Map<String, dynamic>>.from(_cartItems),
            totalAmount: _cartTotal,
          ),
        ),
      ).then((_) {
        // Clear cart after returning from checkout
        _clearCart();
      });
    }
  }

  void _clearCart() {
    setState(() {
      _cartItemCount = 0;
      _cartItems.clear();
      _cartTotal = 0.0;
    });
  }
}