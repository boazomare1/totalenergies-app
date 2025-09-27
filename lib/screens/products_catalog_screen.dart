import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/products_service.dart';

class ProductsCatalogScreen extends StatefulWidget {
  const ProductsCatalogScreen({super.key});

  @override
  State<ProductsCatalogScreen> createState() => _ProductsCatalogScreenState();
}

class _ProductsCatalogScreenState extends State<ProductsCatalogScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  String _selectedCategory = 'all';
  String _selectedSubcategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  String _sortBy = 'name'; // name, price, rating, stock
  bool _showOnlyAvailable = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _products = ProductsService.getAllProducts();
      _filteredProducts = _products;
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts =
          _products.where((product) {
            // Filter by category
            if (_selectedCategory != 'all' &&
                product['category'] != _selectedCategory) {
              return false;
            }

            // Filter by subcategory
            if (_selectedSubcategory != 'all' &&
                product['subcategory'] != _selectedSubcategory) {
              return false;
            }

            // Filter by availability
            if (_showOnlyAvailable && !product['isAvailable']) {
              return false;
            }

            // Filter by search query
            if (_searchQuery.isNotEmpty) {
              final query = _searchQuery.toLowerCase();
              return product['name'].toString().toLowerCase().contains(query) ||
                  product['description'].toString().toLowerCase().contains(
                    query,
                  );
            }

            return true;
          }).toList();

      _sortProducts();
    });
  }

  void _sortProducts() {
    _filteredProducts.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return (a['name'] as String).compareTo(b['name'] as String);
        case 'price':
          return (a['price'] as double).compareTo(b['price'] as double);
        case 'rating':
          return (b['rating'] as double).compareTo(a['rating'] as double);
        case 'stock':
          return (b['stock'] as int).compareTo(a['stock'] as int);
        default:
          return 0;
      }
    });
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductDetailsSheet(product),
    );
  }

  void _showPreOrderDialog(Map<String, dynamic> product) {
    final quantityController = TextEditingController(text: '1');
    final notesController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Pre-order ${product['name']}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product['description'], style: GoogleFonts.poppins()),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Special instructions...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Preferred Date:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 30),
                          ),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFE60012),
                        ),
                      ),
                    ),
                  ],
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
              ElevatedButton(
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text) ?? 1;
                  if (quantity > 0) {
                    _createPreOrder(
                      product,
                      quantity,
                      selectedDate,
                      notesController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60012),
                ),
                child: Text(
                  'Pre-order',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showReserveDialog(Map<String, dynamic> product) {
    final quantityController = TextEditingController(text: '1');
    final notesController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 2));

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Reserve ${product['name']}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product['description'], style: GoogleFonts.poppins()),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Special instructions...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Reservation Time:',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (time != null) {
                          setState(() {
                            selectedDate = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                      child: Text(
                        '${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFE60012),
                        ),
                      ),
                    ),
                  ],
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
              ElevatedButton(
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text) ?? 1;
                  if (quantity > 0) {
                    _createReservation(
                      product,
                      quantity,
                      selectedDate,
                      notesController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60012),
                ),
                child: Text(
                  'Reserve',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _createPreOrder(
    Map<String, dynamic> product,
    int quantity,
    DateTime date,
    String notes,
  ) {
    final result = ProductsService.preOrderProduct(
      productId: product['id'],
      userId: 'current_user', // In real app, get from auth service
      stationId: 'current_station', // In real app, get from location
      quantity: quantity,
      preferredDate: date,
      notes: notes.isNotEmpty ? notes : null,
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pre-order created successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'], style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _createReservation(
    Map<String, dynamic> product,
    int quantity,
    DateTime date,
    String notes,
  ) {
    final result = ProductsService.reserveProduct(
      productId: product['id'],
      userId: 'current_user', // In real app, get from auth service
      stationId: 'current_station', // In real app, get from location
      quantity: quantity,
      reservationDate: date,
      notes: notes.isNotEmpty ? notes : null,
    );

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reservation created successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'], style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Products & Services',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.all_inclusive, size: 20),
                  const SizedBox(width: 8),
                  Text('All', style: GoogleFonts.poppins()),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_gas_station, size: 20),
                  const SizedBox(width: 8),
                  Text('Fuel', style: GoogleFonts.poppins()),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.oil_barrel, size: 20),
                  const SizedBox(width: 8),
                  Text('Lubricants', style: GoogleFonts.poppins()),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.car_repair, size: 20),
                  const SizedBox(width: 8),
                  Text('Car Care', style: GoogleFonts.poppins()),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.build, size: 20),
                  const SizedBox(width: 8),
                  Text('Services', style: GoogleFonts.poppins()),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _applyFilters();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFE60012),
                    ),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                                _applyFilters();
                              },
                              icon: const Icon(Icons.clear, color: Colors.grey),
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE60012),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          hintText: 'Category',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE60012),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text(
                              'All Categories',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          ...ProductsService.getCategories().map((category) {
                            final categoryNames =
                                ProductsService.getCategoryDisplayNames();
                            return DropdownMenuItem(
                              value: category,
                              child: Text(
                                categoryNames[category] ?? category,
                                style: GoogleFonts.poppins(),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                            _selectedSubcategory = 'all';
                          });
                          _applyFilters();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: InputDecoration(
                          hintText: 'Sort by',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE60012),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'name',
                            child: Text('Name', style: GoogleFonts.poppins()),
                          ),
                          DropdownMenuItem(
                            value: 'price',
                            child: Text('Price', style: GoogleFonts.poppins()),
                          ),
                          DropdownMenuItem(
                            value: 'rating',
                            child: Text('Rating', style: GoogleFonts.poppins()),
                          ),
                          DropdownMenuItem(
                            value: 'stock',
                            child: Text('Stock', style: GoogleFonts.poppins()),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sortBy = value!;
                          });
                          _applyFilters();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Filter Options
                Row(
                  children: [
                    Expanded(
                      child: FilterChip(
                        label: Text(
                          'Available Only',
                          style: GoogleFonts.poppins(),
                        ),
                        selected: _showOnlyAvailable,
                        onSelected: (selected) {
                          setState(() {
                            _showOnlyAvailable = selected;
                          });
                          _applyFilters();
                        },
                        selectedColor: const Color(
                          0xFFE60012,
                        ).withValues(alpha: 0.2),
                        checkmarkColor: const Color(0xFFE60012),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_filteredProducts.length} products',
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
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsList(),
                _buildProductsList('fuel'),
                _buildProductsList('lubricants'),
                _buildProductsList('car_care'),
                _buildProductsList('services'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList([String? category]) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE60012)),
      );
    }

    List<Map<String, dynamic>> products = _filteredProducts;
    if (category != null) {
      products =
          _filteredProducts
              .where((product) => product['category'] == category)
              .toList();
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search terms',
              style: GoogleFonts.poppins(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final categoryNames = ProductsService.getCategoryDisplayNames();
    final categoryIcons = ProductsService.getCategoryIcons();
    final isLowStock = product['stock'] > 0 && product['stock'] <= 10;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE60012).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      categoryIcons[product['category']] ?? '📦',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categoryNames[product['category']] ??
                              product['category'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color(0xFFE60012),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            product['rating'].toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (product['price'] > 0)
                        Text(
                          'KSh ${product['price'].toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE60012),
                          ),
                        )
                      else
                        Text(
                          'Price on request',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                product['description'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Stock and Availability
              Row(
                children: [
                  if (product['stock'] > 0) ...[
                    Icon(
                      Icons.inventory,
                      color: isLowStock ? Colors.orange : Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isLowStock
                          ? 'Low stock (${product['stock']})'
                          : 'In stock (${product['stock']})',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isLowStock ? Colors.orange : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else if (product['category'] == 'services') ...[
                    Icon(Icons.schedule, color: Colors.blue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Service available',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Out of stock',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (product['canPreOrder'])
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Pre-order',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (product['canReserve'])
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Reserve',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.green[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Action Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showProductDetails(product),
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: Text('Details', style: GoogleFonts.poppins()),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE60012)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  if (product['canPreOrder'])
                    ElevatedButton.icon(
                      onPressed: () => _showPreOrderDialog(product),
                      icon: const Icon(Icons.schedule, size: 16),
                      label: Text('Pre-order', style: GoogleFonts.poppins()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  if (product['canReserve'])
                    ElevatedButton.icon(
                      onPressed: () => _showReserveDialog(product),
                      icon: const Icon(Icons.bookmark, size: 16),
                      label: Text('Reserve', style: GoogleFonts.poppins()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetailsSheet(Map<String, dynamic> product) {
    final categoryNames = ProductsService.getCategoryDisplayNames();
    final categoryIcons = ProductsService.getCategoryIcons();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Product Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE60012).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  categoryIcons[product['category']] ?? '📦',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoryNames[product['category']] ?? product['category'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFFE60012),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            product['description'],
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          // Price and Rating
          Row(
            children: [
              if (product['price'] > 0) ...[
                Text(
                  'KSh ${product['price'].toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE60012),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  product['unit'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ] else
                Text(
                  'Price on request',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[600], size: 20),
                  const SizedBox(width: 4),
                  Text(
                    product['rating'].toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Specifications
          if (product['specifications'] != null) ...[
            Text(
              'Specifications',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...(product['specifications'] as Map<String, dynamic>).entries.map((
              entry,
            ) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '${entry.key.replaceAll('_', ' ').toUpperCase()}: ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
          // Availability
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  product['isAvailable'] ? Icons.check_circle : Icons.cancel,
                  color: product['isAvailable'] ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  product['isAvailable'] ? 'Available' : 'Not Available',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: product['isAvailable'] ? Colors.green : Colors.red,
                  ),
                ),
                if (product['stock'] > 0) ...[
                  const SizedBox(width: 16),
                  Text(
                    'Stock: ${product['stock']}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          // Action Buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (product['canPreOrder'])
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showPreOrderDialog(product);
                  },
                  icon: const Icon(Icons.schedule, size: 20),
                  label: Text('Pre-order', style: GoogleFonts.poppins()),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              if (product['canReserve'])
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showReserveDialog(product);
                  },
                  icon: const Icon(Icons.bookmark, size: 20),
                  label: Text('Reserve', style: GoogleFonts.poppins()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60012),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
