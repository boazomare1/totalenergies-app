class ProductsService {
  // Sample products data
  static final List<Map<String, dynamic>> _products = [
    // Fuel Products
    {
      'id': '1',
      'name': 'TotalEnergies Excellium Diesel',
      'category': 'fuel',
      'subcategory': 'diesel',
      'description': 'Premium diesel fuel with advanced additives for better engine performance',
      'price': 0.0, // Price per liter
      'unit': 'per liter',
      'imageUrl': 'assets/images/products/diesel.jpg',
      'isAvailable': true,
      'stock': 1000, // liters
      'rating': 4.5,
      'canPreOrder': false,
      'canReserve': false,
      'stationId': 'all', // Available at all stations
      'specifications': {
        'octane_rating': 'N/A',
        'sulfur_content': '< 10 ppm',
        'additives': 'Advanced detergent additives',
        'color': 'Clear',
      },
    },
    {
      'id': '2',
      'name': 'TotalEnergies Excellium Petrol',
      'category': 'fuel',
      'subcategory': 'petrol',
      'description': 'High-quality petrol with enhanced cleaning properties',
      'price': 0.0,
      'unit': 'per liter',
      'imageUrl': 'assets/images/products/petrol.jpg',
      'isAvailable': true,
      'stock': 1000,
      'rating': 4.6,
      'canPreOrder': false,
      'canReserve': false,
      'stationId': 'all',
      'specifications': {
        'octane_rating': '95 RON',
        'sulfur_content': '< 10 ppm',
        'additives': 'Enhanced cleaning additives',
        'color': 'Clear',
      },
    },
    {
      'id': '3',
      'name': 'TotalEnergies LPG',
      'category': 'fuel',
      'subcategory': 'lpg',
      'description': 'Clean burning LPG for cooking and heating',
      'price': 0.0,
      'unit': 'per kg',
      'imageUrl': 'assets/images/products/lpg.jpg',
      'isAvailable': true,
      'stock': 500,
      'rating': 4.4,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'purity': '99.5%',
        'pressure': '8-10 bar',
        'odorant': 'Ethyl mercaptan',
        'color': 'Colorless',
      },
    },
    // Lubricants
    {
      'id': '4',
      'name': 'TotalEnergies Quartz 9000 5W-40',
      'category': 'lubricants',
      'subcategory': 'engine_oil',
      'description': 'Fully synthetic engine oil for modern vehicles',
      'price': 4500.0,
      'unit': 'per 4L',
      'imageUrl': 'assets/images/products/quartz_9000.jpg',
      'isAvailable': true,
      'stock': 50,
      'rating': 4.7,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'viscosity': '5W-40',
        'type': 'Fully Synthetic',
        'api_rating': 'SN/CF',
        'acea_rating': 'A3/B4',
        'capacity': '4L',
      },
    },
    {
      'id': '5',
      'name': 'TotalEnergies Quartz 7000 10W-40',
      'category': 'lubricants',
      'subcategory': 'engine_oil',
      'description': 'Semi-synthetic engine oil for everyday driving',
      'price': 3200.0,
      'unit': 'per 4L',
      'imageUrl': 'assets/images/products/quartz_7000.jpg',
      'isAvailable': true,
      'stock': 75,
      'rating': 4.5,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'viscosity': '10W-40',
        'type': 'Semi-Synthetic',
        'api_rating': 'SN/CF',
        'acea_rating': 'A3/B4',
        'capacity': '4L',
      },
    },
    {
      'id': '6',
      'name': 'TotalEnergies Transmission Fluid',
      'category': 'lubricants',
      'subcategory': 'transmission',
      'description': 'High-performance automatic transmission fluid',
      'price': 2800.0,
      'unit': 'per 1L',
      'imageUrl': 'assets/images/products/transmission_fluid.jpg',
      'isAvailable': true,
      'stock': 30,
      'rating': 4.3,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'type': 'ATF',
        'viscosity': 'Multi-grade',
        'compatibility': 'Most automatic transmissions',
        'capacity': '1L',
      },
    },
    // Car Care Products
    {
      'id': '7',
      'name': 'TotalEnergies Car Shampoo',
      'category': 'car_care',
      'subcategory': 'cleaning',
      'description': 'Gentle car shampoo for safe and effective cleaning',
      'price': 1200.0,
      'unit': 'per 1L',
      'imageUrl': 'assets/images/products/car_shampoo.jpg',
      'isAvailable': true,
      'stock': 40,
      'rating': 4.2,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'ph_level': 'Neutral',
        'concentration': 'High',
        'wax_content': 'None',
        'capacity': '1L',
      },
    },
    {
      'id': '8',
      'name': 'TotalEnergies Tire Shine',
      'category': 'car_care',
      'subcategory': 'tires',
      'description': 'Long-lasting tire shine for a glossy finish',
      'price': 800.0,
      'unit': 'per 500ml',
      'imageUrl': 'assets/images/products/tire_shine.jpg',
      'isAvailable': true,
      'stock': 60,
      'rating': 4.0,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'finish': 'Glossy',
        'duration': '2-3 weeks',
        'application': 'Spray',
        'capacity': '500ml',
      },
    },
    {
      'id': '9',
      'name': 'TotalEnergies Air Freshener',
      'category': 'car_care',
      'subcategory': 'interior',
      'description': 'Long-lasting air freshener with pleasant fragrance',
      'price': 600.0,
      'unit': 'per piece',
      'imageUrl': 'assets/images/products/air_freshener.jpg',
      'isAvailable': true,
      'stock': 100,
      'rating': 4.1,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'fragrance': 'Ocean Breeze',
        'duration': '4-6 weeks',
        'type': 'Hanging',
        'capacity': '1 piece',
      },
    },
    // Convenience Store Items
    {
      'id': '10',
      'name': 'Coca-Cola 500ml',
      'category': 'convenience',
      'subcategory': 'beverages',
      'description': 'Refreshing Coca-Cola soft drink',
      'price': 80.0,
      'unit': 'per bottle',
      'imageUrl': 'assets/images/products/coca_cola.jpg',
      'isAvailable': true,
      'stock': 200,
      'rating': 4.3,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'size': '500ml',
        'type': 'Soft Drink',
        'flavor': 'Cola',
        'sugar_content': 'High',
      },
    },
    {
      'id': '11',
      'name': 'Chips Ahoy Cookies',
      'category': 'convenience',
      'subcategory': 'snacks',
      'description': 'Delicious chocolate chip cookies',
      'price': 150.0,
      'unit': 'per pack',
      'imageUrl': 'assets/images/products/chips_ahoy.jpg',
      'isAvailable': true,
      'stock': 80,
      'rating': 4.4,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'weight': '150g',
        'type': 'Cookies',
        'flavor': 'Chocolate Chip',
        'allergens': 'Contains wheat, eggs, milk',
      },
    },
    {
      'id': '12',
      'name': 'Cigarettes - Marlboro',
      'category': 'convenience',
      'subcategory': 'tobacco',
      'description': 'Premium cigarettes (18+ only)',
      'price': 200.0,
      'unit': 'per pack',
      'imageUrl': 'assets/images/products/marlboro.jpg',
      'isAvailable': true,
      'stock': 50,
      'rating': 4.0,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'type': 'Cigarettes',
        'strength': 'Regular',
        'age_restriction': '18+',
        'quantity': '20 sticks',
      },
    },
    // Services
    {
      'id': '13',
      'name': 'Car Wash Service',
      'category': 'services',
      'subcategory': 'car_wash',
      'description': 'Professional car wash service',
      'price': 500.0,
      'unit': 'per wash',
      'imageUrl': 'assets/images/products/car_wash.jpg',
      'isAvailable': true,
      'stock': 0, // Services don't have stock
      'rating': 4.6,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'duration': '15-20 minutes',
        'type': 'Full Service',
        'includes': 'Exterior wash, interior cleaning',
        'equipment': 'Professional grade',
      },
    },
    {
      'id': '14',
      'name': 'Tire Pressure Check',
      'category': 'services',
      'subcategory': 'maintenance',
      'description': 'Professional tire pressure check and adjustment',
      'price': 200.0,
      'unit': 'per check',
      'imageUrl': 'assets/images/products/tire_check.jpg',
      'isAvailable': true,
      'stock': 0,
      'rating': 4.5,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': 'all',
      'specifications': {
        'duration': '5-10 minutes',
        'type': 'Maintenance',
        'includes': 'Pressure check, adjustment, visual inspection',
        'equipment': 'Digital pressure gauge',
      },
    },
    {
      'id': '15',
      'name': 'EV Charging Service',
      'category': 'services',
      'subcategory': 'ev_charging',
      'description': 'Fast charging for electric vehicles',
      'price': 50.0,
      'unit': 'per kWh',
      'imageUrl': 'assets/images/products/ev_charging.jpg',
      'isAvailable': true,
      'stock': 0,
      'rating': 4.7,
      'canPreOrder': true,
      'canReserve': true,
      'stationId': '2,4,6', // Only at stations with EV charging
      'specifications': {
        'power': '50kW DC',
        'connector': 'CCS, CHAdeMO',
        'duration': '30-60 minutes',
        'compatibility': 'Most EV models',
      },
    },
  ];

  // Get all products
  static List<Map<String, dynamic>> getAllProducts() {
    return List.from(_products);
  }

  // Get products by category
  static List<Map<String, dynamic>> getProductsByCategory(String category) {
    return _products.where((product) {
      return product['category'] == category;
    }).toList();
  }

  // Get products by subcategory
  static List<Map<String, dynamic>> getProductsBySubcategory(String subcategory) {
    return _products.where((product) {
      return product['subcategory'] == subcategory;
    }).toList();
  }

  // Get available products for station
  static List<Map<String, dynamic>> getProductsForStation(String stationId) {
    return _products.where((product) {
      return product['stationId'] == 'all' || 
             product['stationId'] == stationId ||
             (product['stationId'] as String).contains(stationId);
    }).toList();
  }

  // Search products
  static List<Map<String, dynamic>> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    final lowercaseQuery = query.toLowerCase();
    return _products.where((product) {
      return product['name'].toString().toLowerCase().contains(lowercaseQuery) ||
             product['description'].toString().toLowerCase().contains(lowercaseQuery) ||
             product['category'].toString().toLowerCase().contains(lowercaseQuery) ||
             product['subcategory'].toString().toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get product by ID
  static Map<String, dynamic>? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get available categories
  static List<String> getCategories() {
    final categories = <String>{};
    for (final product in _products) {
      categories.add(product['category']);
    }
    return categories.toList()..sort();
  }

  // Get available subcategories
  static List<String> getSubcategories(String category) {
    final subcategories = <String>{};
    for (final product in _products) {
      if (product['category'] == category) {
        subcategories.add(product['subcategory']);
      }
    }
    return subcategories.toList()..sort();
  }

  // Get category display names
  static Map<String, String> getCategoryDisplayNames() {
    return {
      'fuel': 'Fuel',
      'lubricants': 'Lubricants',
      'car_care': 'Car Care',
      'convenience': 'Convenience Store',
      'services': 'Services',
    };
  }

  // Get category icons
  static Map<String, String> getCategoryIcons() {
    return {
      'fuel': '⛽',
      'lubricants': '🛢️',
      'car_care': '🚗',
      'convenience': '🏪',
      'services': '🔧',
    };
  }

  // Pre-order product
  static Map<String, dynamic> preOrderProduct({
    required String productId,
    required String userId,
    required String stationId,
    required int quantity,
    required DateTime preferredDate,
    String? notes,
  }) {
    final product = getProductById(productId);
    
    if (product == null) {
      return {
        'success': false,
        'message': 'Product not found',
      };
    }

    if (!product['canPreOrder']) {
      return {
        'success': false,
        'message': 'This product cannot be pre-ordered',
      };
    }

    if (!product['isAvailable']) {
      return {
        'success': false,
        'message': 'Product is not available',
      };
    }

    // Check if product is available at station
    if (product['stationId'] != 'all' && 
        !product['stationId'].toString().contains(stationId)) {
      return {
        'success': false,
        'message': 'Product not available at this station',
      };
    }

    // Simulate pre-order creation
    final preOrderId = 'PO${DateTime.now().millisecondsSinceEpoch}';
    
    // In a real app, this would save to database
    print('Pre-order created: $preOrderId for product: $productId');
    
    return {
      'success': true,
      'message': 'Pre-order created successfully',
      'preOrderId': preOrderId,
      'product': product,
      'quantity': quantity,
      'preferredDate': preferredDate,
      'notes': notes,
    };
  }

  // Reserve product
  static Map<String, dynamic> reserveProduct({
    required String productId,
    required String userId,
    required String stationId,
    required int quantity,
    required DateTime reservationDate,
    String? notes,
  }) {
    final product = getProductById(productId);
    
    if (product == null) {
      return {
        'success': false,
        'message': 'Product not found',
      };
    }

    if (!product['canReserve']) {
      return {
        'success': false,
        'message': 'This product cannot be reserved',
      };
    }

    if (!product['isAvailable']) {
      return {
        'success': false,
        'message': 'Product is not available',
      };
    }

    // Check stock for physical products
    if (product['stock'] > 0 && product['stock'] < quantity) {
      return {
        'success': false,
        'message': 'Insufficient stock available',
      };
    }

    // Check if product is available at station
    if (product['stationId'] != 'all' && 
        !product['stationId'].toString().contains(stationId)) {
      return {
        'success': false,
        'message': 'Product not available at this station',
      };
    }

    // Simulate reservation creation
    final reservationId = 'RES${DateTime.now().millisecondsSinceEpoch}';
    
    // In a real app, this would save to database
    print('Reservation created: $reservationId for product: $productId');
    
    return {
      'success': true,
      'message': 'Reservation created successfully',
      'reservationId': reservationId,
      'product': product,
      'quantity': quantity,
      'reservationDate': reservationDate,
      'notes': notes,
    };
  }

  // Get product statistics
  static Map<String, dynamic> getProductStats() {
    final totalProducts = _products.length;
    final availableProducts = _products.where((p) => p['isAvailable']).length;
    final preOrderableProducts = _products.where((p) => p['canPreOrder']).length;
    final reservableProducts = _products.where((p) => p['canReserve']).length;
    
    return {
      'total': totalProducts,
      'available': availableProducts,
      'preOrderable': preOrderableProducts,
      'reservable': reservableProducts,
      'byCategory': {
        for (final category in getCategories())
          category: getProductsByCategory(category).length,
      },
    };
  }

  // Get featured products
  static List<Map<String, dynamic>> getFeaturedProducts() {
    return _products.where((product) {
      return product['isAvailable'] && 
             (product['rating'] as double) >= 4.5;
    }).take(6).toList();
  }

  // Get recently added products
  static List<Map<String, dynamic>> getRecentlyAddedProducts() {
    // In a real app, this would be based on creation date
    return _products.take(5).toList();
  }

  // Get low stock products
  static List<Map<String, dynamic>> getLowStockProducts() {
    return _products.where((product) {
      return product['stock'] > 0 && product['stock'] <= 10;
    }).toList();
  }
}