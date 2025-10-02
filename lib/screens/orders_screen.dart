import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/hive_database_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _currentUserId;

  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> _defaultOrders = [
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
      'trackingInfo': {
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
      },
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
      'trackingInfo': {
        'currentLocation': 'At service bay - Oil change in progress',
        'estimatedDelivery': '2024-01-12 11:30',
        'lastUpdate': '2024-01-12 10:15',
        'trackingSteps': [
          {'step': 'Order Confirmed', 'time': '09:15', 'completed': true},
          {'step': 'Vehicle Inspection', 'time': '09:25', 'completed': true},
          {'step': 'Fuel Service', 'time': '09:45', 'completed': true},
          {'step': 'Oil Change', 'time': '10:15', 'completed': false},
          {'step': 'Quality Check', 'time': '11:00', 'completed': false},
          {'step': 'Ready for Pickup', 'time': '11:30', 'completed': false},
        ],
      },
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
      'trackingInfo': {
        'currentLocation': 'Order cancelled by customer',
        'estimatedDelivery': null,
        'lastUpdate': '2024-01-10 17:20',
        'trackingSteps': [
          {'step': 'Order Confirmed', 'time': '16:45', 'completed': true},
          {'step': 'Preparing Order', 'time': '16:50', 'completed': false},
          {'step': 'Order Cancelled', 'time': '17:20', 'completed': true},
        ],
      },
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeOrders();
  }

  Future<void> _initializeOrders() async {
    try {
      // Get current user ID from settings or use a default
      _currentUserId =
          HiveDatabaseService.getSetting<String>('current_user_id') ??
          'demo_user';

      // Load orders from Hive
      final savedOrders = HiveDatabaseService.getUserOrders(_currentUserId!);

      if (savedOrders.isEmpty) {
        // If no saved orders, use default orders and save them
        _orders = List.from(_defaultOrders);
        for (final order in _defaultOrders) {
          order['userId'] = _currentUserId;
          await HiveDatabaseService.saveOrder(order);
        }
      } else {
        _orders = savedOrders;
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing orders: $e');
      // Fallback to default orders
      _orders = List.from(_defaultOrders);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredOrders {
    List<Map<String, dynamic>> filtered = _orders;

    // Apply status filter
    if (_selectedFilter != 'All') {
      filtered =
          filtered
              .where((order) => order['status'] == _selectedFilter)
              .toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchQuery = _searchController.text.toLowerCase();
      filtered =
          filtered.where((order) {
            return order['id'].toLowerCase().contains(searchQuery) ||
                order['station'].toLowerCase().contains(searchQuery);
          }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by order number...',
                    hintStyle: GoogleFonts.poppins(color: Colors.white70),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  autofocus: true,
                )
                : Text(
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
          if (_isSearching)
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              icon: const Icon(Icons.close, color: Colors.white),
            )
          else
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: const Icon(Icons.search, color: Colors.white),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'All', child: Text('All Orders')),
                  const PopupMenuItem(
                    value: 'Delivered',
                    child: Text('Delivered'),
                  ),
                  const PopupMenuItem(
                    value: 'In Progress',
                    child: Text('In Progress'),
                  ),
                  const PopupMenuItem(
                    value: 'Cancelled',
                    child: Text('Cancelled'),
                  ),
                ],
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
        bottom:
            _isSearching
                ? null
                : TabBar(
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
      body:
          _isSearching
              ? _buildSearchResults()
              : TabBarView(
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
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
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
                  child: Icon(statusIcon, color: statusColor, size: 24),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
              children:
                  order['items'].map<Widget>((item) {
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
                Icon(Icons.payment, size: 16, color: Colors.grey[500]),
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
                if (order['status'] == 'In Progress') const SizedBox(width: 12),
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
                if (order['status'] == 'Delivered') const SizedBox(width: 12),
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
          Icon(Icons.favorite_outline, size: 80, color: Colors.grey[400]),
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
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final searchResults = _filteredOrders;

    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Search Orders',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter an order number to track your order',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    if (searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
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
              'No orders match "${_searchController.text}"',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _trackOrderByNumber(_searchController.text);
              },
              icon: const Icon(Icons.track_changes),
              label: const Text('Track Order'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final order = searchResults[index];
        return _buildOrderCard(order);
      },
    );
  }

  void _createNewOrder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
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
                        const SizedBox(height: 12),
                        _buildQuickOrderOption(
                          'LPG Cylinders',
                          'Choose your gas cylinder size and type',
                          Icons.local_fire_department,
                          () => _navigateToLPGOrder(),
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

  Widget _buildQuickOrderOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
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
          child: Icon(icon, color: const Color(0xFFE60012), size: 24),
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
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _rateOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
    _showOrderTrackingModal(order);
  }

  void _trackOrderByNumber(String orderNumber) {
    // Simulate tracking an order that might not be in the user's list
    final trackingInfo = {
      'currentLocation': 'At warehouse - Preparing for dispatch',
      'estimatedDelivery': '2024-01-20 14:30',
      'lastUpdate': '2024-01-20 10:15',
      'trackingSteps': [
        {'step': 'Order Confirmed', 'time': '09:00', 'completed': true},
        {'step': 'Processing', 'time': '09:15', 'completed': true},
        {'step': 'Preparing', 'time': '10:15', 'completed': false},
        {'step': 'Ready for Dispatch', 'time': '12:00', 'completed': false},
        {'step': 'Out for Delivery', 'time': '13:30', 'completed': false},
        {'step': 'Delivered', 'time': '14:30', 'completed': false},
      ],
    };

    final mockOrder = {
      'id': orderNumber,
      'date': '2024-01-20',
      'time': '09:00',
      'station': 'TotalEnergies Central',
      'status': 'In Progress',
      'total': 0.00,
      'items': [],
      'paymentMethod': 'Unknown',
      'rating': null,
      'trackingInfo': trackingInfo,
    };

    _showOrderTrackingModal(mockOrder);
  }

  void _showOrderTrackingModal(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
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
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE60012).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.track_changes,
                          color: Color(0xFFE60012),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Tracking',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              order['id'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                // Current Status
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Current Location',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order['trackingInfo']['currentLocation'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      if (order['trackingInfo']['estimatedDelivery'] !=
                          null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.blue[700],
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Estimated completion: ${order['trackingInfo']['estimatedDelivery']}',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.update, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Last updated: ${order['trackingInfo']['lastUpdate']}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Tracking Steps
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Tracking Progress',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Steps List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: order['trackingInfo']['trackingSteps'].length,
                    itemBuilder: (context, index) {
                      final step =
                          order['trackingInfo']['trackingSteps'][index];
                      final isCompleted = step['completed'];
                      final isLast =
                          index ==
                          order['trackingInfo']['trackingSteps'].length - 1;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline indicator
                          Column(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color:
                                      isCompleted
                                          ? Colors.green
                                          : Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child:
                                    isCompleted
                                        ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                        : null,
                              ),
                              if (!isLast)
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.grey[300],
                                ),
                            ],
                          ),

                          const SizedBox(width: 12),

                          // Step content
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step['step'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isCompleted
                                              ? Colors.black87
                                              : Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    step['time'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _viewOrderDetails(order);
                          },
                          icon: const Icon(Icons.info_outline, size: 16),
                          label: const Text('Order Details'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE60012),
                            side: const BorderSide(color: Color(0xFFE60012)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Refreshing tracking information...',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: const Color(0xFFE60012),
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Refresh'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE60012),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
          ),
    );
  }

  void _viewOrderDetails(Map<String, dynamic> order) {
    // For now, show a simple dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Order Details',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: ${order['id']}', style: GoogleFonts.poppins()),
                Text(
                  'Station: ${order['station']}',
                  style: GoogleFonts.poppins(),
                ),
                Text(
                  'Status: ${order['status']}',
                  style: GoogleFonts.poppins(),
                ),
                Text(
                  'Total: KSh ${order['total'].toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(),
                ),
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
    _createImmediateOrder('Fuel Order', 'Fuel Service');
  }

  void _navigateToServicesOrder() {
    Navigator.pop(context);
    _createImmediateOrder('Car Services', 'Car Maintenance');
  }

  void _navigateToShopOrder() {
    Navigator.pop(context);
    _createImmediateOrder('Shop Items', 'Convenience Store');
  }

  void _navigateToRestaurantOrder() {
    Navigator.pop(context);
    _createImmediateOrder('Restaurant Order', 'Food & Beverages');
  }

  void _navigateToLPGOrder() {
    Navigator.pop(context);
    _showLPGOrderModal();
  }

  void _createImmediateOrder(String orderType, String category) {
    // Generate a new order ID
    final orderId =
        'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // Create new order with tracking info
    final newOrder = {
      'id': orderId,
      'userId': _currentUserId ?? 'demo_user',
      'date': dateStr,
      'time': timeStr,
      'station': 'TotalEnergies ${orderType.split(' ').first}',
      'status': 'In Progress',
      'total': _generateOrderTotal(orderType),
      'items': _generateOrderItems(orderType),
      'paymentMethod': 'TotalEnergies Card',
      'rating': null,
      'trackingInfo': {
        'currentLocation': 'Order confirmed - Processing...',
        'estimatedDelivery': _getEstimatedDelivery(now),
        'lastUpdate': '$dateStr $timeStr',
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
      },
    };

    // Add to orders list (at the beginning for immediate visibility)
    setState(() {
      _orders.insert(0, newOrder);
    });

    // Switch to Recent tab to show the new order
    _tabController.animateTo(0);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Created Successfully!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Order ID: $orderId',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Track',
          textColor: Colors.white,
          onPressed: () => _trackOrder(newOrder),
        ),
      ),
    );
  }

  double _generateOrderTotal(String orderType) {
    switch (orderType) {
      case 'Fuel Order':
        return 1800.00 + (DateTime.now().millisecondsSinceEpoch % 500);
      case 'Car Services':
        return 2500.00 + (DateTime.now().millisecondsSinceEpoch % 1000);
      case 'Shop Items':
        return 450.00 + (DateTime.now().millisecondsSinceEpoch % 300);
      case 'Restaurant Order':
        return 750.00 + (DateTime.now().millisecondsSinceEpoch % 400);
      case 'LPG Order':
        return 4800.00 + (DateTime.now().millisecondsSinceEpoch % 2000);
      default:
        return 1000.00;
    }
  }

  List<Map<String, dynamic>> _generateOrderItems(String orderType) {
    switch (orderType) {
      case 'Fuel Order':
        return [
          {'name': 'Petrol', 'quantity': 10, 'price': 180.50, 'total': 1805.00},
        ];
      case 'Car Services':
        return [
          {
            'name': 'Oil Change',
            'quantity': 1,
            'price': 800.00,
            'total': 800.00,
          },
          {'name': 'Car Wash', 'quantity': 1, 'price': 500.00, 'total': 500.00},
          {
            'name': 'Tire Check',
            'quantity': 1,
            'price': 200.00,
            'total': 200.00,
          },
        ];
      case 'Shop Items':
        return [
          {
            'name': 'Water Bottle',
            'quantity': 2,
            'price': 50.00,
            'total': 100.00,
          },
          {'name': 'Snacks', 'quantity': 3, 'price': 80.00, 'total': 240.00},
        ];
      case 'Restaurant Order':
        return [
          {'name': 'Coffee', 'quantity': 2, 'price': 150.00, 'total': 300.00},
          {'name': 'Sandwich', 'quantity': 1, 'price': 450.00, 'total': 450.00},
        ];
      case 'LPG Order':
        return [
          {
            'name': '13kg LPG Cylinder',
            'quantity': 1,
            'price': 4800.00,
            'total': 4800.00,
          },
        ];
      default:
        return [
          {
            'name': 'Service',
            'quantity': 1,
            'price': 1000.00,
            'total': 1000.00,
          },
        ];
    }
  }

  String _getEstimatedDelivery(DateTime now) {
    final estimated = now.add(const Duration(minutes: 30));
    return '${estimated.year}-${estimated.month.toString().padLeft(2, '0')}-${estimated.day.toString().padLeft(2, '0')} ${estimated.hour.toString().padLeft(2, '0')}:${estimated.minute.toString().padLeft(2, '0')}';
  }

  String _getNextTime(DateTime now, int minutes) {
    final next = now.add(Duration(minutes: minutes));
    return '${next.hour.toString().padLeft(2, '0')}:${next.minute.toString().padLeft(2, '0')}';
  }

  void _showLPGOrderModal() {
    final Map<String, int> selectedCylinders = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.85,
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
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFE60012,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.local_fire_department,
                              color: Color(0xFFE60012),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order LPG Cylinders',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Choose your gas cylinder size and quantity',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),

                    // LPG Options
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          // 6kg Cylinder
                          _buildLPGCylinderOption(
                            '6kg LPG Cylinder',
                            'Perfect for small households',
                            'KSh 2,500.00',
                            2500.00,
                            selectedCylinders['6kg'] ?? 0,
                            (quantity) {
                              setModalState(() {
                                if (quantity == 0) {
                                  selectedCylinders.remove('6kg');
                                } else {
                                  selectedCylinders['6kg'] = quantity;
                                }
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          // 13kg Cylinder
                          _buildLPGCylinderOption(
                            '13kg LPG Cylinder',
                            'Standard size for most families',
                            'KSh 4,800.00',
                            4800.00,
                            selectedCylinders['13kg'] ?? 0,
                            (quantity) {
                              setModalState(() {
                                if (quantity == 0) {
                                  selectedCylinders.remove('13kg');
                                } else {
                                  selectedCylinders['13kg'] = quantity;
                                }
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          // 22kg Cylinder
                          _buildLPGCylinderOption(
                            '22kg LPG Cylinder',
                            'Large cylinder for big families',
                            'KSh 8,200.00',
                            8200.00,
                            selectedCylinders['22kg'] ?? 0,
                            (quantity) {
                              setModalState(() {
                                if (quantity == 0) {
                                  selectedCylinders.remove('22kg');
                                } else {
                                  selectedCylinders['22kg'] = quantity;
                                }
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          // 50kg Cylinder
                          _buildLPGCylinderOption(
                            '50kg LPG Cylinder',
                            'Commercial size cylinder',
                            'KSh 18,500.00',
                            18500.00,
                            selectedCylinders['50kg'] ?? 0,
                            (quantity) {
                              setModalState(() {
                                if (quantity == 0) {
                                  selectedCylinders.remove('50kg');
                                } else {
                                  selectedCylinders['50kg'] = quantity;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Order Button
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              selectedCylinders.isNotEmpty
                                  ? () => _placeLPGOrder(selectedCylinders)
                                  : null,
                          icon: const Icon(Icons.shopping_cart),
                          label: Text(
                            selectedCylinders.isEmpty
                                ? 'Select Cylinders to Order'
                                : 'Place LPG Order',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedCylinders.isNotEmpty
                                    ? const Color(0xFFE60012)
                                    : Colors.grey[400],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildLPGCylinderOption(
    String title,
    String description,
    String price,
    double unitPrice,
    int selectedQuantity,
    Function(int) onQuantityChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              selectedQuantity > 0
                  ? const Color(0xFFE60012)
                  : Colors.grey[200]!,
          width: selectedQuantity > 0 ? 2 : 1,
        ),
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE60012).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Color(0xFFE60012),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE60012),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Quantity Selector
          Row(
            children: [
              Text(
                'Quantity:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  // Decrease Button
                  GestureDetector(
                    onTap:
                        selectedQuantity > 0
                            ? () => onQuantityChanged(selectedQuantity - 1)
                            : null,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            selectedQuantity > 0
                                ? const Color(0xFFE60012)
                                : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        color:
                            selectedQuantity > 0
                                ? Colors.white
                                : Colors.grey[600],
                        size: 16,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Quantity Display
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text(
                      selectedQuantity.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Increase Button
                  GestureDetector(
                    onTap: () => onQuantityChanged(selectedQuantity + 1),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE60012),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Subtotal
          if (selectedQuantity > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'KSh ${(unitPrice * selectedQuantity).toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE60012),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _placeLPGOrder(Map<String, int> selectedCylinders) {
    Navigator.pop(context);

    // Generate order items from selected cylinders
    final List<Map<String, dynamic>> orderItems = [];
    final prices = {
      '6kg': 2500.00,
      '13kg': 4800.00,
      '22kg': 8200.00,
      '50kg': 18500.00,
    };

    selectedCylinders.forEach((size, quantity) {
      if (prices.containsKey(size)) {
        final price = prices[size]!;
        orderItems.add({
          'name': '${size} LPG Cylinder',
          'quantity': quantity,
          'price': price,
          'total': price * quantity,
        });
      }
    });

    // Create the order with custom items
    _createCustomLPGOrder(orderItems);
  }

  void _createCustomLPGOrder(List<Map<String, dynamic>> items) {
    // Generate a new order ID
    final orderId =
        'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    // Calculate total
    final total = items.fold(0.0, (sum, item) => sum + item['total']);

    // Create new order with tracking info
    final newOrder = {
      'id': orderId,
      'date': dateStr,
      'time': timeStr,
      'station': 'TotalEnergies LPG Center',
      'status': 'In Progress',
      'total': total,
      'items': items,
      'paymentMethod': 'TotalEnergies Card',
      'rating': null,
      'trackingInfo': {
        'currentLocation': 'Order confirmed - Processing LPG cylinders...',
        'estimatedDelivery': _getEstimatedDelivery(now),
        'lastUpdate': '$dateStr $timeStr',
        'trackingSteps': [
          {'step': 'Order Confirmed', 'time': timeStr, 'completed': true},
          {
            'step': 'Processing Payment',
            'time': _getNextTime(now, 2),
            'completed': false,
          },
          {
            'step': 'Preparing Cylinders',
            'time': _getNextTime(now, 5),
            'completed': false,
          },
          {
            'step': 'Quality Check',
            'time': _getNextTime(now, 10),
            'completed': false,
          },
          {
            'step': 'Loading for Delivery',
            'time': _getNextTime(now, 15),
            'completed': false,
          },
          {
            'step': 'Out for Delivery',
            'time': _getNextTime(now, 20),
            'completed': false,
          },
          {
            'step': 'Delivered',
            'time': _getNextTime(now, 30),
            'completed': false,
          },
        ],
      },
    };

    // Add to orders list (at the beginning for immediate visibility)
    setState(() {
      _orders.insert(0, newOrder);
    });

    // Switch to Recent tab to show the new order
    _tabController.animateTo(0);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LPG Order Created Successfully!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Order ID: $orderId • ${items.length} item(s)',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Track',
          textColor: Colors.white,
          onPressed: () => _trackOrder(newOrder),
        ),
      ),
    );
  }
}
