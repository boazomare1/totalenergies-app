class StationService {
  // Sample station data for Kenya
  static final List<Map<String, dynamic>> _stations = [
    {
      'id': '1',
      'name': 'TotalEnergies Westlands',
      'address': 'Waiyaki Way, Westlands, Nairobi',
      'latitude': -1.2644,
      'longitude': 36.8080,
      'phone': '+254 20 1234567',
      'services': ['fuel', 'shop', 'car_wash', 'atm'],
      'is24Hours': true,
      'hasEVCharging': false,
      'hasLPG': true,
      'rating': 4.5,
      'distance': 2.3, // km from user location
      'estimatedTime': 8, // minutes
    },
    {
      'id': '2',
      'name': 'TotalEnergies Thika Road',
      'address': 'Thika Road, Kasarani, Nairobi',
      'latitude': -1.2000,
      'longitude': 36.9000,
      'phone': '+254 20 2345678',
      'services': ['fuel', 'shop', 'car_wash', 'atm', 'restaurant'],
      'is24Hours': true,
      'hasEVCharging': true,
      'hasLPG': true,
      'rating': 4.7,
      'distance': 5.2,
      'estimatedTime': 15,
    },
    {
      'id': '3',
      'name': 'TotalEnergies Mombasa Road',
      'address': 'Mombasa Road, Industrial Area, Nairobi',
      'latitude': -1.3000,
      'longitude': 36.8500,
      'phone': '+254 20 3456789',
      'services': ['fuel', 'shop', 'car_wash'],
      'is24Hours': false,
      'hasEVCharging': false,
      'hasLPG': true,
      'rating': 4.2,
      'distance': 7.8,
      'estimatedTime': 22,
    },
    {
      'id': '4',
      'name': 'TotalEnergies Nakuru',
      'address': 'Nakuru-Nairobi Highway, Nakuru',
      'latitude': -0.3000,
      'longitude': 36.0833,
      'phone': '+254 51 4567890',
      'services': ['fuel', 'shop', 'car_wash', 'atm', 'restaurant', 'hotel'],
      'is24Hours': true,
      'hasEVCharging': true,
      'hasLPG': true,
      'rating': 4.6,
      'distance': 150.0,
      'estimatedTime': 120,
    },
    {
      'id': '5',
      'name': 'TotalEnergies Kisumu',
      'address': 'Kisumu-Migori Road, Kisumu',
      'latitude': -0.0917,
      'longitude': 34.7680,
      'phone': '+254 57 5678901',
      'services': ['fuel', 'shop', 'car_wash', 'atm'],
      'is24Hours': true,
      'hasEVCharging': false,
      'hasLPG': true,
      'rating': 4.3,
      'distance': 350.0,
      'estimatedTime': 240,
    },
    {
      'id': '6',
      'name': 'TotalEnergies Eldoret',
      'address': 'Eldoret-Nakuru Highway, Eldoret',
      'latitude': 0.5167,
      'longitude': 35.2833,
      'phone': '+254 53 6789012',
      'services': ['fuel', 'shop', 'car_wash', 'atm', 'restaurant'],
      'is24Hours': true,
      'hasEVCharging': true,
      'hasLPG': true,
      'rating': 4.4,
      'distance': 300.0,
      'estimatedTime': 180,
    },
    {
      'id': '7',
      'name': 'TotalEnergies Mombasa',
      'address': 'Mombasa-Malindi Road, Mombasa',
      'latitude': -4.0437,
      'longitude': 39.6682,
      'phone': '+254 41 7890123',
      'services': ['fuel', 'shop', 'car_wash', 'atm', 'restaurant', 'hotel'],
      'is24Hours': true,
      'hasEVCharging': false,
      'hasLPG': true,
      'rating': 4.8,
      'distance': 450.0,
      'estimatedTime': 300,
    },
    {
      'id': '8',
      'name': 'TotalEnergies Meru',
      'address': 'Meru-Nairobi Road, Meru',
      'latitude': 0.0500,
      'longitude': 37.6500,
      'phone': '+254 64 8901234',
      'services': ['fuel', 'shop', 'car_wash'],
      'is24Hours': false,
      'hasEVCharging': false,
      'hasLPG': true,
      'rating': 4.1,
      'distance': 200.0,
      'estimatedTime': 150,
    },
  ];

  // Get all stations
  static List<Map<String, dynamic>> getAllStations() {
    return List.from(_stations);
  }

  // Get stations by filters
  static List<Map<String, dynamic>> getStationsByFilters({
    bool? is24Hours,
    bool? hasEVCharging,
    bool? hasLPG,
    List<String>? requiredServices,
    double? maxDistance,
  }) {
    return _stations.where((station) {
      if (is24Hours != null && station['is24Hours'] != is24Hours) {
        return false;
      }
      if (hasEVCharging != null && station['hasEVCharging'] != hasEVCharging) {
        return false;
      }
      if (hasLPG != null && station['hasLPG'] != hasLPG) {
        return false;
      }
      if (requiredServices != null) {
        final stationServices = List<String>.from(station['services']);
        if (!requiredServices.every((service) => stationServices.contains(service))) {
          return false;
        }
      }
      if (maxDistance != null && station['distance'] > maxDistance) {
        return false;
      }
      return true;
    }).toList();
  }

  // Get nearest stations
  static List<Map<String, dynamic>> getNearestStations({
    double? userLatitude,
    double? userLongitude,
    int limit = 10,
  }) {
    final stations = List<Map<String, dynamic>>.from(_stations);
    
    // Sort by distance (in real app, would calculate actual distance)
    stations.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    
    return stations.take(limit).toList();
  }

  // Search stations by name or address
  static List<Map<String, dynamic>> searchStations(String query) {
    if (query.isEmpty) return _stations;
    
    final lowercaseQuery = query.toLowerCase();
    return _stations.where((station) {
      return station['name'].toString().toLowerCase().contains(lowercaseQuery) ||
             station['address'].toString().toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get station by ID
  static Map<String, dynamic>? getStationById(String id) {
    try {
      return _stations.firstWhere((station) => station['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get available services
  static List<String> getAvailableServices() {
    final allServices = <String>{};
    for (final station in _stations) {
      allServices.addAll(List<String>.from(station['services']));
    }
    return allServices.toList()..sort();
  }

  // Get service display names
  static Map<String, String> getServiceDisplayNames() {
    return {
      'fuel': 'Fuel',
      'shop': 'Convenience Store',
      'car_wash': 'Car Wash',
      'atm': 'ATM',
      'restaurant': 'Restaurant',
      'hotel': 'Hotel',
    };
  }

  // Get service icons
  static Map<String, String> getServiceIcons() {
    return {
      'fuel': '⛽',
      'shop': '🏪',
      'car_wash': '🚿',
      'atm': '🏧',
      'restaurant': '🍽️',
      'hotel': '🏨',
    };
  }

  // Calculate distance between two coordinates (simplified)
  static double calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    // Simplified distance calculation
    // In a real app, use proper Haversine formula
    final latDiff = lat1 - lat2;
    final lonDiff = lon1 - lon2;
    return (latDiff * latDiff + lonDiff * lonDiff) * 111.32; // Rough km conversion
  }

  // Get route directions (simulated)
  static Map<String, dynamic> getRouteDirections({
    required double fromLat,
    required double fromLon,
    required double toLat,
    required double toLon,
  }) {
    // Simulate route calculation
    final distance = calculateDistance(fromLat, fromLon, toLat, toLon);
    final estimatedTime = (distance * 1.5).round(); // Rough time estimate
    
    return {
      'distance': distance,
      'estimatedTime': estimatedTime,
      'route': [
        {'lat': fromLat, 'lon': fromLon, 'instruction': 'Start from current location'},
        {'lat': (fromLat + toLat) / 2, 'lon': (fromLon + toLon) / 2, 'instruction': 'Continue straight'},
        {'lat': toLat, 'lon': toLon, 'instruction': 'Arrive at destination'},
      ],
    };
  }

  // Get user's current location (simulated)
  static Map<String, double> getCurrentLocation() {
    // In a real app, this would use GPS
    return {
      'latitude': -1.2921, // Nairobi coordinates
      'longitude': 36.8219,
    };
  }
}