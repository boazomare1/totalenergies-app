import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/station_service.dart';

class EnhancedStationLocatorScreen extends StatefulWidget {
  const EnhancedStationLocatorScreen({super.key});

  @override
  State<EnhancedStationLocatorScreen> createState() =>
      _EnhancedStationLocatorScreenState();
}

class _EnhancedStationLocatorScreenState
    extends State<EnhancedStationLocatorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _filteredStations = [];
  String _searchQuery = '';
  bool _isLoading = false;
  Map<String, bool> _selectedFilters = {
    'is24Hours': false,
    'hasEVCharging': false,
    'hasLPG': false,
    'fuel': false,
    'shop': false,
    'car_wash': false,
    'atm': false,
    'restaurant': false,
    'hotel': false,
  };
  String _sortBy = 'distance'; // distance, rating, name
  Map<String, double>? _currentLocation;
  Map<String, dynamic>? _routeInfo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadStations();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStations() async {
    setState(() {
      _isLoading = true;
    });

    // Load stations without artificial delay
    final stations = StationService.getAllStations();

    if (mounted) {
      setState(() {
        _filteredStations = stations;
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    // Get current location without artificial delay
    final location = StationService.getCurrentLocation();
    if (mounted) {
      setState(() {
        _currentLocation = location;
      });
    }
  }

  void _applyFilters() {
    // Perform filtering operations without setState first
    List<Map<String, dynamic>> filteredStations =
        StationService.getStationsByFilters(
          is24Hours: _selectedFilters['is24Hours'] == true ? true : null,
          hasEVCharging:
              _selectedFilters['hasEVCharging'] == true ? true : null,
          hasLPG: _selectedFilters['hasLPG'] == true ? true : null,
          requiredServices: _getSelectedServices(),
        );

    if (_searchQuery.isNotEmpty) {
      filteredStations = StationService.searchStations(_searchQuery);
    }

    // Sort the filtered stations
    filteredStations = _sortStationsList(filteredStations);

    // Update state once with all changes
    if (mounted) {
      setState(() {
        _filteredStations = filteredStations;
      });
    }
  }

  List<String> _getSelectedServices() {
    return _selectedFilters.entries
        .where(
          (entry) =>
              entry.key != 'is24Hours' &&
              entry.key != 'hasEVCharging' &&
              entry.key != 'hasLPG' &&
              entry.value,
        )
        .map((entry) => entry.key)
        .toList();
  }

  List<Map<String, dynamic>> _sortStationsList(
    List<Map<String, dynamic>> stations,
  ) {
    final sortedStations = List<Map<String, dynamic>>.from(stations);
    sortedStations.sort((a, b) {
      switch (_sortBy) {
        case 'distance':
          return (a['distance'] as double).compareTo(b['distance'] as double);
        case 'rating':
          return (b['rating'] as double).compareTo(a['rating'] as double);
        case 'name':
          return (a['name'] as String).compareTo(b['name'] as String);
        default:
          return 0;
      }
    });
    return sortedStations;
  }

  void _showStationDetails(Map<String, dynamic> station) {
    setState(() {
      // Station details will be shown in the modal
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildStationDetailsSheet(station),
    );
  }

  void _getDirections(Map<String, dynamic> station) {
    if (_currentLocation == null) return;

    setState(() {
      _routeInfo = StationService.getRouteDirections(
        fromLat: _currentLocation!['latitude']?.toDouble() ?? 0.0,
        fromLon: _currentLocation!['longitude']?.toDouble() ?? 0.0,
        toLat: station['latitude']?.toDouble() ?? 0.0,
        toLon: station['longitude']?.toDouble() ?? 0.0,
      );
    });

    _showRouteDialog(station);
  }

  void _showRouteDialog(Map<String, dynamic> station) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Directions to ${station['name']}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_routeInfo != null) ...[
                  _buildRouteInfo(
                    'Distance',
                    '${_routeInfo!['distance'].toStringAsFixed(1)} km',
                  ),
                  _buildRouteInfo(
                    'Estimated Time',
                    '${_routeInfo!['estimatedTime']} minutes',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Route Instructions:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ...(_routeInfo!['route'] as List).map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${step['instruction']}',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ),
                ],
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // In a real app, open external maps app
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening in Maps app...',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60012),
                ),
                child: Text(
                  'Open in Maps',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildRouteInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Station Locator',
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
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.list, size: 20),
                  const SizedBox(width: 8),
                  Text('List', style: GoogleFonts.poppins()),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, size: 20),
                  const SizedBox(width: 8),
                  Text('Map', style: GoogleFonts.poppins()),
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
                    hintText: 'Search stations...',
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
                // Filter and Sort Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showFilterDialog,
                        icon: const Icon(Icons.filter_list, size: 18),
                        label: Text('Filters', style: GoogleFonts.poppins()),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE60012)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
                            value: 'distance',
                            child: Text(
                              'Distance',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'rating',
                            child: Text('Rating', style: GoogleFonts.poppins()),
                          ),
                          DropdownMenuItem(
                            value: 'name',
                            child: Text('Name', style: GoogleFonts.poppins()),
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
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildStationList(), _buildStationMap()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE60012)),
      );
    }

    if (_filteredStations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No stations found',
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
      itemCount: _filteredStations.length,
      itemBuilder: (context, index) {
        final station = _filteredStations[index];
        return _buildStationCard(station);
      },
    );
  }

  Widget _buildStationCard(Map<String, dynamic> station) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showStationDetails(station),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          station['address'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
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
                            station['rating'].toString(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${station['distance'].toStringAsFixed(1)} km',
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
              // Services
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    (station['services'] as List).map((service) {
                      final serviceNames =
                          StationService.getServiceDisplayNames();
                      final serviceIcons = StationService.getServiceIcons();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE60012).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              serviceIcons[service] ?? '📍',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              serviceNames[service] ?? service,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFFE60012),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 12),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _getDirections(station),
                      icon: const Icon(Icons.directions, size: 16),
                      label: Text('Directions', style: GoogleFonts.poppins()),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE60012)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showStationDetails(station),
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: Text('Details', style: GoogleFonts.poppins()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60012),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildStationMap() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Map Placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Interactive Map',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Map integration would show here\nwith station markers and routes',
                      style: GoogleFonts.poppins(color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Station Count
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredStations.length} stations found',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                if (_currentLocation != null)
                  Text(
                    'Location: ${_currentLocation!['latitude']?.toStringAsFixed(2) ?? 'N/A'}, ${_currentLocation!['longitude']?.toStringAsFixed(2) ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Stations',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilters = {
                      'is24Hours': false,
                      'hasEVCharging': false,
                      'hasLPG': false,
                      'fuel': false,
                      'shop': false,
                      'car_wash': false,
                      'atm': false,
                      'restaurant': false,
                      'hotel': false,
                    };
                  });
                  _applyFilters();
                  Navigator.pop(context);
                },
                child: Text(
                  'Clear All',
                  style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Station Features
          Text(
            'Station Features',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildFilterChip('is24Hours', '24 Hours'),
          _buildFilterChip('hasEVCharging', 'EV Charging'),
          _buildFilterChip('hasLPG', 'LPG Available'),
          const SizedBox(height: 20),
          // Services
          Text(
            'Available Services',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildServiceFilterChip('fuel', 'Fuel'),
              _buildServiceFilterChip('shop', 'Shop'),
              _buildServiceFilterChip('car_wash', 'Car Wash'),
              _buildServiceFilterChip('atm', 'ATM'),
              _buildServiceFilterChip('restaurant', 'Restaurant'),
              _buildServiceFilterChip('hotel', 'Hotel'),
            ],
          ),
          const SizedBox(height: 30),
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _applyFilters();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    return CheckboxListTile(
      value: _selectedFilters[key] ?? false,
      onChanged: (value) {
        setState(() {
          _selectedFilters[key] = value ?? false;
        });
      },
      title: Text(label, style: GoogleFonts.poppins()),
      activeColor: const Color(0xFFE60012),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildServiceFilterChip(String key, String label) {
    final isSelected = _selectedFilters[key] ?? false;
    return FilterChip(
      label: Text(label, style: GoogleFonts.poppins()),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilters[key] = selected;
        });
      },
      selectedColor: const Color(0xFFE60012).withValues(alpha: 0.2),
      checkmarkColor: const Color(0xFFE60012),
    );
  }

  Widget _buildStationDetailsSheet(Map<String, dynamic> station) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
          // Station Name
          Text(
            station['name'],
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Address
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  station['address'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Rating and Distance
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[600], size: 20),
                  const SizedBox(width: 4),
                  Text(
                    station['rating'].toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  Icon(Icons.directions, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${station['distance'].toStringAsFixed(1)} km',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${station['estimatedTime']} min',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Services
          Text(
            'Available Services',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                (station['services'] as List).map((service) {
                  final serviceNames = StationService.getServiceDisplayNames();
                  final serviceIcons = StationService.getServiceIcons();
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE60012).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          serviceIcons[service] ?? '📍',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          serviceNames[service] ?? service,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFE60012),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),
          // Contact Info
          if (station['phone'] != null) ...[
            Text(
              'Contact Information',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  station['phone'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _getDirections(station);
                  },
                  icon: const Icon(Icons.directions, size: 20),
                  label: Text('Get Directions', style: GoogleFonts.poppins()),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE60012)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // In a real app, make a phone call
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Calling ${station['phone']}...',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone, size: 20),
                  label: Text('Call', style: GoogleFonts.poppins()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60012),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
