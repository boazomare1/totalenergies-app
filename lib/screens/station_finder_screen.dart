import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StationFinderScreen extends StatefulWidget {
  const StationFinderScreen({super.key});

  @override
  State<StationFinderScreen> createState() => _StationFinderScreenState();
}

class _StationFinderScreenState extends State<StationFinderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _selectedSort = 'Distance';
  bool _showMap = true;

  final List<Map<String, dynamic>> _stations = [
    {
      'id': '1',
      'name': 'TotalEnergies Westlands',
      'address': 'Westlands Road, Nairobi',
      'distance': '2.3 km',
      'rating': 4.5,
      'services': ['Fuel', 'Car Wash', 'Restaurant', 'ATM'],
      'isOpen': true,
      'price': 'KSh 180.50',
      'lat': -1.2701,
      'lng': 36.8081,
    },
    {
      'id': '2',
      'name': 'TotalEnergies Karen',
      'address': 'Karen Shopping Centre, Nairobi',
      'distance': '4.7 km',
      'rating': 4.3,
      'services': ['Fuel', 'Car Wash', 'Restaurant', 'Shop'],
      'isOpen': true,
      'price': 'KSh 180.50',
      'lat': -1.3197,
      'lng': 36.6850,
    },
    {
      'id': '3',
      'name': 'TotalEnergies Thika Road',
      'address': 'Thika Road, Nairobi',
      'distance': '6.2 km',
      'rating': 4.1,
      'services': ['Fuel', 'Car Wash', 'ATM'],
      'isOpen': false,
      'price': 'KSh 180.50',
      'lat': -1.2000,
      'lng': 36.9000,
    },
    {
      'id': '4',
      'name': 'TotalEnergies Mombasa Road',
      'address': 'Mombasa Road, Nairobi',
      'distance': '8.1 km',
      'rating': 4.4,
      'services': ['Fuel', 'Car Wash', 'Restaurant', 'Shop', 'ATM'],
      'isOpen': true,
      'price': 'KSh 180.50',
      'lat': -1.3000,
      'lng': 36.8000,
    },
    {
      'id': '5',
      'name': 'TotalEnergies Kiambu',
      'address': 'Kiambu Town Centre',
      'distance': '12.5 km',
      'rating': 4.2,
      'services': ['Fuel', 'Car Wash', 'Restaurant'],
      'isOpen': true,
      'price': 'KSh 180.50',
      'lat': -1.1667,
      'lng': 36.8333,
    },
  ];

  List<Map<String, dynamic>> get _filteredStations {
    var filtered =
        _stations.where((station) {
          if (_selectedFilter == 'Open Now' && !station['isOpen']) return false;
          if (_selectedFilter == 'With Restaurant' &&
              !station['services'].contains('Restaurant'))
            return false;
          if (_selectedFilter == 'With Car Wash' &&
              !station['services'].contains('Car Wash'))
            return false;
          if (_selectedFilter == 'With ATM' &&
              !station['services'].contains('ATM'))
            return false;
          return true;
        }).toList();

    // Sort by distance or rating
    if (_selectedSort == 'Distance') {
      filtered.sort(
        (a, b) => double.parse(
          a['distance'].split(' ')[0],
        ).compareTo(double.parse(b['distance'].split(' ')[0])),
      );
    } else if (_selectedSort == 'Rating') {
      filtered.sort((a, b) => b['rating'].compareTo(a['rating']));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Find Station',
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
            icon: Icon(_showMap ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _showMap = !_showMap;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by location or station name...',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFE60012),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Filter and Sort Row
                Row(
                  children: [
                    // Filter Dropdown
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedFilter,
                            isExpanded: true,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                            hint: Text(
                              'Filter',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'All',
                                child: Text('All Stations'),
                              ),
                              DropdownMenuItem(
                                value: 'Open Now',
                                child: Text('Open Now'),
                              ),
                              DropdownMenuItem(
                                value: 'With Restaurant',
                                child: Text('With Restaurant'),
                              ),
                              DropdownMenuItem(
                                value: 'With Car Wash',
                                child: Text('With Car Wash'),
                              ),
                              DropdownMenuItem(
                                value: 'With ATM',
                                child: Text('With ATM'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedFilter = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Sort Dropdown
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSort,
                            isExpanded: true,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                            hint: Text(
                              'Sort',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Distance',
                                child: Text('Distance'),
                              ),
                              DropdownMenuItem(
                                value: 'Rating',
                                child: Text('Rating'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(child: _showMap ? _buildMapView() : _buildListView()),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Map Placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Map View',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Interactive map with station locations',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showMap = false;
                    });
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('View List'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60012),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Station Count Badge
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE60012),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${_filteredStations.length} stations found',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
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
          // Station Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Station Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        station['isOpen']
                            ? const Color(0xFFE60012).withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_gas_station,
                    color:
                        station['isOpen']
                            ? const Color(0xFFE60012)
                            : Colors.grey[400],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Station Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            station['distance'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.star, size: 14, color: Colors.amber[600]),
                          const SizedBox(width: 4),
                          Text(
                            station['rating'].toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        station['isOpen']
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    station['isOpen'] ? 'Open' : 'Closed',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color:
                          station['isOpen']
                              ? Colors.green[700]
                              : Colors.red[700],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Services
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  station['services'].map<Widget>((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE60012).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        service,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: const Color(0xFFE60012),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Price and Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Price - takes minimal space
                Text(
                  'Price: ${station['price']}/L',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE60012),
                  ),
                ),
                const SizedBox(width: 4),
                // Details button with icon
                TextButton.icon(
                  onPressed: () {
                    _showStationDetails(station);
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(0xFFE60012),
                  ),
                  label: Text(
                    'Details', 
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE60012),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFE60012),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Navigate button with icon - takes remaining space
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed:
                        station['isOpen']
                            ? () {
                              _navigateToStation(station);
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE60012),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.directions, size: 16),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'GO', 
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withValues(alpha: 0.8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  void _showStationDetails(Map<String, dynamic> station) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
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
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          station['address'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Status and Rating
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    station['isOpen']
                                        ? Colors.green.withValues(alpha: 0.1)
                                        : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                station['isOpen'] ? 'Open Now' : 'Closed',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      station['isOpen']
                                          ? Colors.green[700]
                                          : Colors.red[700],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${station['rating']} (4.2/5)',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Services
                        Text(
                          'Available Services',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              station['services'].map<Widget>((service) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFE60012,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    service,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0xFFE60012),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),

                        const SizedBox(height: 24),

                        // Price
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
                                Icons.local_gas_station,
                                color: const Color(0xFFE60012),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Current Price: ',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                station['price'] + '/L',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE60012),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                          },
                          icon: const Icon(Icons.call),
                          label: const Text('Call Station'),
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
                          onPressed:
                              station['isOpen']
                                  ? () {
                                    Navigator.pop(context);
                                    _navigateToStation(station);
                                  }
                                  : null,
                          icon: const Icon(Icons.directions),
                          label: const Text('Navigate'),
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

  void _navigateToStation(Map<String, dynamic> station) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigating to ${station['name']}...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
