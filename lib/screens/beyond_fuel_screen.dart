import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'food_order_screen.dart';

class BeyondFuelScreen extends StatefulWidget {
  const BeyondFuelScreen({Key? key}) : super(key: key);

  @override
  State<BeyondFuelScreen> createState() => _BeyondFuelScreenState();
}

class _BeyondFuelScreenState extends State<BeyondFuelScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _foodOptions = [
    {
      'id': 'KFC-001',
      'name': 'KFC',
      'description': 'Famous fried chicken and sides',
      'category': 'Fast Food',
      'image': 'assets/images/banner_kfc_bg.png',
      'rating': 4.5,
      'deliveryTime': '15-20 min',
      'priceRange': 'KSh 500-1500',
      'isAvailable': true,
      'station': 'TotalEnergies Westlands',
      'address': 'Westlands, Nairobi',
    },
    {
      'id': 'MUGG-001',
      'name': 'Mugg & Bean',
      'description': 'Coffee, breakfast, and light meals',
      'category': 'Coffee & Cafe',
      'image': 'assets/images/banner_enjoy_bg.png',
      'rating': 4.3,
      'deliveryTime': '10-15 min',
      'priceRange': 'KSh 300-800',
      'isAvailable': true,
      'station': 'TotalEnergies Karen',
      'address': 'Karen, Nairobi',
    },
    {
      'id': 'SUBWAY-001',
      'name': 'Subway',
      'description': 'Fresh sandwiches and salads',
      'category': 'Healthy',
      'image': 'assets/images/banner_enjoy_bg.png',
      'rating': 4.2,
      'deliveryTime': '12-18 min',
      'priceRange': 'KSh 400-900',
      'isAvailable': true,
      'station': 'TotalEnergies Thika Road',
      'address': 'Thika Road, Nairobi',
    },
    {
      'id': 'PIZZA-001',
      'name': 'Pizza Inn',
      'description': 'Fresh pizza and Italian cuisine',
      'category': 'Italian',
      'image': 'assets/images/banner_enjoy_bg.png',
      'rating': 4.4,
      'deliveryTime': '20-25 min',
      'priceRange': 'KSh 800-2000',
      'isAvailable': true,
      'station': 'TotalEnergies Mombasa Road',
      'address': 'Mombasa Road, Nairobi',
    },
    {
      'id': 'BURGER-001',
      'name': 'Burger King',
      'description': 'Flame-grilled burgers and fries',
      'category': 'Fast Food',
      'image': 'assets/images/banner_enjoy_bg.png',
      'rating': 4.1,
      'deliveryTime': '15-20 min',
      'priceRange': 'KSh 600-1200',
      'isAvailable': true,
      'station': 'TotalEnergies Nakuru',
      'address': 'Nakuru Town',
    },
    {
      'id': 'COFFEE-001',
      'name': 'Java House',
      'description': 'Premium coffee and pastries',
      'category': 'Coffee & Cafe',
      'image': 'assets/images/banner_enjoy_bg.png',
      'rating': 4.6,
      'deliveryTime': '8-12 min',
      'priceRange': 'KSh 200-600',
      'isAvailable': true,
      'station': 'TotalEnergies Kisumu',
      'address': 'Kisumu City',
    },
  ];

  final List<String> _categories = [
    'All',
    'Fast Food',
    'Coffee & Cafe',
    'Healthy',
    'Italian',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOptions =
        _foodOptions.where((option) {
          final matchesCategory =
              _selectedCategory == 'All' ||
              option['category'] == _selectedCategory;
          final matchesSearch =
              option['name'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              option['description'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
          return matchesCategory && matchesSearch;
        }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.beyondFuel,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: GoogleFonts.poppins(
                        color:
                            isSelected ? Colors.white : const Color(0xFFE60012),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFFE60012),
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color:
                          isSelected
                              ? const Color(0xFFE60012)
                              : Colors.grey[300]!,
                    ),
                  ),
                );
              },
            ),
          ),
          // Food Options List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOptions.length,
              itemBuilder: (context, index) {
                final option = filteredOptions[index];
                return _buildFoodOptionCard(option);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodOptionCard(Map<String, dynamic> option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Status
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  option['image'] as String,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
              // Availability Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: option['isAvailable'] ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    option['isAvailable'] ? 'Available' : 'Closed',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Rating Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        option['rating'].toString(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        option['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE60012).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        option['category'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFE60012),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  option['description'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                // Station Info
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFE60012),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        option['station'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  option['address'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 12),
                // Details Row
                Row(
                  children: [
                    _buildDetailChip(
                      Icons.access_time,
                      option['deliveryTime'] as String,
                    ),
                    const SizedBox(width: 8),
                    _buildDetailChip(
                      Icons.attach_money,
                      option['priceRange'] as String,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        option['isAvailable'] ? () => _orderFood(option) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE60012),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      option['isAvailable'] ? 'Order Now' : 'Currently Closed',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Search Food Options',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or description...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                  });
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _orderFood(Map<String, dynamic> option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodOrderScreen(restaurant: option),
      ),
    );
  }
}
