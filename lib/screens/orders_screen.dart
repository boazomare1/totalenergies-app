import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _orders = [
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
        {'name': 'Air Freshener', 'quantity': 2, 'price': 72.50, 'total': 145.00},
      ],
      'paymentMethod': 'TotalEnergies Card',
      'rating': 5,
    },
    {
      'id': 'ORD-002',
      'date': '2024-01-12',
      'time': '09:15',
      'station': 'TotalEnergies Karen',
      'status': 'In Progress',
      'total': 1200.00,
      'items': [
        {'name': 'Diesel', 'quantity': 5, 'price': 175.00, 'total': 875.00},
        {'name': 'Oil Change', 'quantity': 1, 'price': 325.00, 'total': 325.00},
      ],
      'paymentMethod': 'Mobile Money',
      'rating': null,
    },
    {
      'id': 'ORD-003',
      'date': '2024-01-10',
      'time': '16:45',
      'station': 'TotalEnergies Thika Road',
      'status': 'Cancelled',
      'total': 850.00,
      'items': [
        {'name': 'Petrol', 'quantity': 4, 'price': 180.50, 'total': 722.00},
        {'name': 'Car Wash', 'quantity': 1, 'price': 500.00, 'total': 500.00},
      ],
      'paymentMethod': 'Cash',
      'rating': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All Orders')),
              const PopupMenuItem(value: 'Delivered', child: Text('Delivered')),
              const PopupMenuItem(value: 'In Progress', child: Text('In Progress')),
              const PopupMenuItem(value: 'Cancelled', child: Text('Cancelled')),
            ],
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Recent'),
            Tab(text: 'History'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(),
          _buildOrdersList(),
          _buildFavoritesList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewOrder,
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          'New Order',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your orders will appear here',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor;
    IconData statusIcon;
    
    switch (order['status']) {
      case 'Delivered':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'In Progress':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Order Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['id'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order['station'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order['date']} at ${order['time']}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order['status'],
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'KSh ${order['total'].toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE60012),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Order Items
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: order['items'].map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        '${item['quantity']}x',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'KSh ${item['total'].toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Payment Method
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.payment,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 8),
                Text(
                  'Paid via ${order['paymentMethod']}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (order['status'] == 'Delivered' && order['rating'] == null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _rateOrder(order),
                      icon: const Icon(Icons.star, size: 16),
                      label: const Text('Rate Order'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE60012),
                        side: const BorderSide(color: Color(0xFFE60012)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (order['status'] == 'Delivered' && order['rating'] == null)
                  const SizedBox(width: 12),
                if (order['status'] == 'In Progress')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _trackOrder(order),
                      icon: const Icon(Icons.track_changes, size: 16),
                      label: const Text('Track Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60012),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (order['status'] == 'In Progress')
                  const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewOrderDetails(order),
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE60012),
                      side: const BorderSide(color: Color(0xFFE60012)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (order['status'] == 'Delivered')
                  const SizedBox(width: 12),
                if (order['status'] == 'Delivered')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _reorderItems(order),
                      icon: const Icon(Icons.replay, size: 16),
                      label: const Text('Reorder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60012),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to favorites for quick reordering',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _createNewOrder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
              child: Row(
                children: [
                  Text(
                    'Create New Order',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Quick Order Options
                    _buildQuickOrderOption(
                      'Fuel Only',
                      'Order fuel for your vehicle',
                      Icons.local_gas_station,
                      () => _navigateToFuelOrder(),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickOrderOption(
                      'Car Services',
                      'Car wash, oil change, maintenance',
                      Icons.car_repair,
                      () => _navigateToServicesOrder(),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickOrderOption(
                      'Shop Items',
                      'Convenience store items',
                      Icons.shopping_cart,
                      () => _navigateToShopOrder(),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickOrderOption(
                      'Restaurant',
                      'Food and beverages',
                      Icons.restaurant,
                      () => _navigateToRestaurantOrder(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOrderOption(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFE60012).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE60012),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _rateOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rate Your Order',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How was your experience with ${order['station']}?',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Thank you for your rating!',
                          style: GoogleFonts.poppins(),
                        ),
                        backgroundColor: const Color(0xFFE60012),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.star,
                    color: Colors.amber[600],
                    size: 30,
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  void _trackOrder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tracking order ${order['id']}...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
      ),
    );
  }

  void _viewOrderDetails(Map<String, dynamic> order) {
    // For now, show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Order Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order['id']}', style: GoogleFonts.poppins()),
            Text('Station: ${order['station']}', style: GoogleFonts.poppins()),
            Text('Status: ${order['status']}', style: GoogleFonts.poppins()),
            Text('Total: KSh ${order['total'].toStringAsFixed(2)}', style: GoogleFonts.poppins()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
            ),
          ),
        ],
      ),
    );
  }

  void _reorderItems(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Adding items to cart for reorder...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
      ),
    );
  }

  void _navigateToFuelOrder() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening fuel order...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
      ),
    );
  }

  void _navigateToServicesOrder() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening car services...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
      ),
    );
  }

  void _navigateToShopOrder() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening shop...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
      ),
    );
  }

  void _navigateToRestaurantOrder() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening restaurant...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
      ),
    );
  }
}