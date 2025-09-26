import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkout_screen.dart';

class GasProductsScreen extends StatefulWidget {
  const GasProductsScreen({super.key});

  @override
  State<GasProductsScreen> createState() => _GasProductsScreenState();
}

class _GasProductsScreenState extends State<GasProductsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _cartItems = [];
  int _cartItemCount = 0;

  final List<Map<String, dynamic>> _cylinders = [
    {
      'id': 1,
      'name': '6kg Gas Cylinder',
      'description': 'Standard 6kg LPG cylinder for home use',
      'price': 2500.0,
      'image': 'assets/images/cylinder_6kg.png',
    },
    {
      'id': 2,
      'name': '13kg Gas Cylinder',
      'description': 'Large 13kg LPG cylinder for heavy usage',
      'price': 4500.0,
      'image': 'assets/images/cylinder_13kg.png',
    },
    {
      'id': 3,
      'name': '50kg Gas Cylinder',
      'description': 'Commercial 50kg LPG cylinder',
      'price': 15000.0,
      'image': 'assets/images/cylinder_50kg.png',
    },
  ];

  final List<Map<String, dynamic>> _accessories = [
    {
      'id': 1,
      'name': 'Gas Regulator',
      'description': 'High-quality gas regulator',
      'price': 800.0,
      'category': 'regulator',
    },
    {
      'id': 2,
      'name': 'Gas Hose',
      'description': 'Flexible gas hose pipe',
      'price': 300.0,
      'category': 'hose',
    },
    {
      'id': 3,
      'name': 'Gas Burner',
      'description': 'Single burner gas stove',
      'price': 1200.0,
      'category': 'burner',
    },
    {
      'id': 4,
      'name': 'Gas Grill',
      'description': 'Outdoor gas grill',
      'price': 3500.0,
      'category': 'grill',
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

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add(Map<String, dynamic>.from(product));
      _cartItemCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: _viewCart,
        ),
      ),
    );
  }

  void _buyNow(Map<String, dynamic> product) {
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
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    double totalAmount = _cartItems.fold(0.0, (sum, item) => sum + item['price']);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          cartItems: _cartItems,
          totalAmount: totalAmount,
        ),
      ),
    ).then((_) {
      _clearCart();
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
      _cartItemCount = 0;
    });
  }

  IconData _getAccessoryIcon(String category) {
    switch (category) {
      case 'regulator':
        return Icons.settings;
      case 'hose':
        return Icons.cable;
      case 'burner':
        return Icons.local_fire_department;
      case 'grill':
        return Icons.outdoor_grill;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TotalEnergies Gas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Cylinders'),
            Tab(text: 'Accessories'),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: _viewCart,
                icon: const Icon(Icons.shopping_cart),
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _cylinders.length,
        itemBuilder: (context, index) {
          final cylinder = _cylinders[index];
          return _buildCylinderCard(cylinder);
        },
      ),
    );
  }

  Widget _buildAccessoriesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _accessories.length,
        itemBuilder: (context, index) {
          final accessory = _accessories[index];
          return _buildAccessoryCard(accessory);
        },
      ),
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
              child: Center(
                child: Icon(
                  Icons.local_gas_station,
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
              padding: const EdgeInsets.all(8),
              child: ClipRect(
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
                    const SizedBox(height: 1),
                    Text(
                      'KES ${cylinder['price'].toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE60012),
                      ),
                    ),
                    
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
                              padding: const EdgeInsets.symmetric(vertical: 2),
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
                              padding: const EdgeInsets.symmetric(vertical: 2),
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
              padding: const EdgeInsets.all(8),
              child: ClipRect(
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
                    const SizedBox(height: 1),
                    Text(
                      'KES ${accessory['price'].toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE60012),
                      ),
                    ),
                    
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
                              padding: const EdgeInsets.symmetric(vertical: 2),
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
                              padding: const EdgeInsets.symmetric(vertical: 2),
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
          ),
        ],
      ),
    );
  }
}