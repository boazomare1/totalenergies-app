import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuartzOilFinderScreen extends StatefulWidget {
  const QuartzOilFinderScreen({super.key});

  @override
  State<QuartzOilFinderScreen> createState() => _QuartzOilFinderScreenState();
}

class _QuartzOilFinderScreenState extends State<QuartzOilFinderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedUserType = 'vehicle_owner';
  String _selectedCountry = 'Kenya';
  String _selectedVehicleType = 'cars';
  String _selectedMake = '';
  String _selectedModel = '';
  String _selectedYear = '';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _oilSearchController = TextEditingController();

  final List<Map<String, dynamic>> _vehicleTypes = [
    {'id': 'cars', 'name': 'Cars', 'icon': Icons.directions_car},
    {'id': 'trucks', 'name': 'Trucks', 'icon': Icons.local_shipping},
    {'id': 'motorcycles', 'name': 'Motorcycles', 'icon': Icons.motorcycle},
    {'id': 'heavy_equipment', 'name': 'Heavy Equipment', 'icon': Icons.construction},
  ];

  final List<Map<String, dynamic>> _carMakes = [
    {'name': 'Toyota', 'models': ['Corolla', 'Camry', 'RAV4', 'Hilux', 'Land Cruiser']},
    {'name': 'Honda', 'models': ['Civic', 'Accord', 'CR-V', 'Pilot']},
    {'name': 'Nissan', 'models': ['Sentra', 'Altima', 'Rogue', 'Pathfinder']},
    {'name': 'Ford', 'models': ['Focus', 'Fusion', 'Escape', 'Explorer']},
    {'name': 'BMW', 'models': ['3 Series', '5 Series', 'X3', 'X5']},
    {'name': 'Mercedes-Benz', 'models': ['C-Class', 'E-Class', 'GLC', 'GLE']},
  ];

  final List<String> _years = List.generate(25, (index) => (2024 - index).toString());

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How can I use the Quartz product finder?',
      'answer': 'The Quartz product finder helps you find the right engine oil for your vehicle. Simply select your vehicle type, make, model, and year, or search by license plate. You can also search directly by oil name or specifications.',
    },
    {
      'question': 'Where can I buy Quartz engine oils and fluids?',
      'answer': 'Quartz engine oils and fluids are available at TotalEnergies service stations, authorized dealers, and online through our official partners. Use our station finder to locate the nearest TotalEnergies station.',
    },
    {
      'question': 'What vehicles can I use the product finder tool for?',
      'answer': 'The Quartz product finder supports cars, trucks, motorcycles, and heavy equipment. We cover most major vehicle brands and models manufactured from 2000 onwards.',
    },
    {
      'question': 'What if my vehicle isn\'t listed in the product finder?',
      'answer': 'If your vehicle isn\'t listed, you can contact our technical support team or visit a TotalEnergies service station where our experts can help you find the right Quartz oil for your specific vehicle.',
    },
    {
      'question': 'What makes Quartz engine oil different from other brands?',
      'answer': 'Quartz engine oils are formulated with advanced technology to provide superior protection, improved fuel economy, and extended engine life. They meet and exceed international standards and are specifically designed for African driving conditions.',
    },
    {
      'question': 'What type of oil does my car need?',
      'answer': 'The type of oil your car needs depends on several factors including engine type, age, driving conditions, and manufacturer specifications. Use our product finder or consult your vehicle manual for the recommended oil grade and viscosity.',
    },
    {
      'question': 'Popular oil types for cars',
      'answer': 'Popular Quartz oil types for cars include:\n• Quartz 7000 5W-30 (Synthetic)\n• Quartz 5000 10W-40 (Semi-synthetic)\n• Quartz 3000 15W-40 (Mineral)\n• Quartz 9000 0W-20 (Full synthetic)',
    },
    {
      'question': 'Oil options for motorcycles',
      'answer': 'For motorcycles, Quartz offers specialized oils including:\n• Quartz Moto 4T 10W-40 (4-stroke engines)\n• Quartz Moto 2T (2-stroke engines)\n• Quartz Moto Racing 10W-50 (High-performance)',
    },
    {
      'question': 'Are synthetic oils better than mineral oils?',
      'answer': 'Synthetic oils generally offer better performance, longer service intervals, and superior protection in extreme temperatures. However, the best choice depends on your vehicle\'s requirements, driving conditions, and budget. Our product finder will recommend the most suitable option.',
    },
    {
      'question': 'How often should I check my oil?',
      'answer': 'Check your engine oil level at least once a month or before long trips. For most vehicles, oil changes are recommended every 5,000-10,000 kilometers or every 6 months, whichever comes first. Check your owner\'s manual for specific recommendations.',
    },
    {
      'question': 'How do I check my oil level?',
      'answer': '1. Park on level ground and turn off the engine\n2. Wait 5-10 minutes for oil to settle\n3. Pull out the dipstick, wipe it clean\n4. Reinsert fully, then pull out again\n5. Check oil level between the min/max marks\n6. Add oil if needed, but don\'t overfill',
    },
    {
      'question': 'How do I refill my oil level?',
      'answer': '1. Remove the oil filler cap\n2. Add small amounts of the correct oil type\n3. Wait a few minutes for oil to settle\n4. Check level with dipstick\n5. Repeat until level is between min/max marks\n6. Replace filler cap securely',
    },
    {
      'question': 'Engine maintenance tips',
      'answer': '• Change oil and filter regularly\n• Check oil level monthly\n• Use the correct oil grade for your engine\n• Follow manufacturer service intervals\n• Keep engine clean and well-ventilated\n• Monitor for leaks or unusual noises\n• Use quality fuel and additives when recommended',
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
    _searchController.dispose();
    _licensePlateController.dispose();
    _oilSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Quartz',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[700]!, Colors.green[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FIND THE RIGHT QUARTZ PRODUCTS',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get the right Quartz® fluid or oil for your vehicle or equipment',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // User Type Selection
                  Row(
                    children: [
                      Expanded(
                        child: _buildUserTypeCard(
                          'Vehicle Owner',
                          _selectedUserType == 'vehicle_owner',
                          () => setState(() => _selectedUserType = 'vehicle_owner'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildUserTypeCard(
                          'Workshop Owner?',
                          _selectedUserType == 'workshop_owner',
                          () => setState(() => _selectedUserType = 'workshop_owner'),
                          isWorkshop: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Search Method Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.grey[600],
              onTap: (index) {
                // Handle tab selection
              },
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car, size: 20),
                      const SizedBox(width: 8),
                      Text('Vehicle & Equipment', style: GoogleFonts.poppins(fontSize: 12)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 20),
                      const SizedBox(width: 8),
                      Text('License Plate', style: GoogleFonts.poppins(fontSize: 12)),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.oil_barrel, size: 20),
                      const SizedBox(width: 8),
                      Text('Oil Search', style: GoogleFonts.poppins(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content Area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVehicleEquipmentSearch(),
                _buildLicensePlateSearch(),
                _buildOilSearch(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeCard(String title, bool isSelected, VoidCallback onTap, {bool isWorkshop = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWorkshop) ...[
              Icon(
                Icons.arrow_forward,
                color: isSelected ? Colors.green : Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.green : Colors.white,
              ),
            ),
            if (!isWorkshop) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.info_outline,
                color: isSelected ? Colors.green : Colors.white,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleEquipmentSearch() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type to search or select from the dropdown below',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by brand or model',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                suffixIcon: Icon(Icons.mic, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // OR Divider
          Center(
            child: Text(
              'OR',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Selection Cards
          _buildSelectionCard('Cars', _selectedVehicleType == 'cars', Icons.directions_car, () {
            setState(() => _selectedVehicleType = 'cars');
          }),
          _buildSelectionCard('Make', _selectedMake.isNotEmpty, Icons.branding_watermark, () {
            _showMakeDialog();
          }),
          _buildSelectionCard('Model', _selectedModel.isNotEmpty, Icons.directions_car, () {
            _showModelDialog();
          }),
          _buildSelectionCard('Year', _selectedYear.isNotEmpty, Icons.calendar_today, () {
            _showYearDialog();
          }),
          
          const SizedBox(height: 32),
          
          // Search Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _searchForOil,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Search',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // FAQs Section
          _buildFAQsSection(),
        ],
      ),
    );
  }

  Widget _buildLicensePlateSearch() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country Selection
          Text(
            'Please specify your country.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedCountry,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[500]),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Vehicle Type Selection
          Text(
            'Please specify vehicle type',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _vehicleTypes.map<Widget>((type) {
              final isSelected = _selectedVehicleType == type['id'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedVehicleType = type['id']),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          type['icon'] as IconData,
                          color: isSelected ? Colors.green : Colors.grey[600],
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          type['name'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.green : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // License Plate Input
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _licensePlateController,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: 'GB123AB',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.grey[400],
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Search Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _searchByLicensePlate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Search',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // FAQs Section
          _buildFAQsSection(),
        ],
      ),
    );
  }

  Widget _buildOilSearch() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FLUID & OIL SEARCH',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Oil Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _oilSearchController,
              decoration: InputDecoration(
                hintText: 'Search by the oil name',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                suffixIcon: Icon(Icons.mic, color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Popular Oils
          Text(
            'Popular Quartz Oils',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          ..._buildPopularOils(),
          
          const SizedBox(height: 24),
          
          // FAQs Section
          _buildFAQsSection(),
        ],
      ),
    );
  }

  Widget _buildSelectionCard(String title, bool isSelected, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.green : Colors.grey[600],
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.green : Colors.black87,
                        ),
                      ),
                      if (title == 'Make' && _selectedMake.isNotEmpty)
                        Text(
                          _selectedMake,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        )
                      else if (title == 'Model' && _selectedModel.isNotEmpty)
                        Text(
                          _selectedModel,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        )
                      else if (title == 'Year' && _selectedYear.isNotEmpty)
                        Text(
                          _selectedYear,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        )
                      else
                        Text(
                          title == 'Cars' ? 'Select vehicle type' : 'Type or select ${title.toLowerCase()}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPopularOils() {
    final popularOils = [
      {'name': 'Quartz 7000 5W-30', 'type': 'Synthetic', 'color': Colors.blue},
      {'name': 'Quartz 5000 10W-40', 'type': 'Semi-synthetic', 'color': Colors.green},
      {'name': 'Quartz 3000 15W-40', 'type': 'Mineral', 'color': Colors.orange},
      {'name': 'Quartz 9000 0W-20', 'type': 'Full Synthetic', 'color': Colors.purple},
    ];

    return popularOils.map((oil) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _searchOilByName(oil['name'] as String),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (oil['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.oil_barrel,
                    color: oil['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        oil['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        oil['type'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    )).toList();
  }

  Widget _buildFAQsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 2,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        Text(
          'Quartz product finder FAQs',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ..._faqs.map((faq) => _buildFAQItem(faq)),
      ],
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: ExpansionTile(
          title: Text(
            faq['question'] as String,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                faq['answer'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMakeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Make', style: GoogleFonts.poppins()),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _carMakes.length,
            itemBuilder: (context, index) {
              final make = _carMakes[index];
              return ListTile(
                title: Text(make['name'], style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() {
                    _selectedMake = make['name'];
                    _selectedModel = '';
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showModelDialog() {
    if (_selectedMake.isEmpty) return;
    
    final selectedMakeData = _carMakes.firstWhere((make) => make['name'] == _selectedMake);
    final models = selectedMakeData['models'] as List<String>;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Model', style: GoogleFonts.poppins()),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: models.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(models[index], style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() => _selectedModel = models[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showYearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Year', style: GoogleFonts.poppins()),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _years.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_years[index], style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() => _selectedYear = _years[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _searchForOil() {
    // Implement oil search logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Searching for Quartz oil for ${_selectedVehicleType} ${_selectedMake} ${_selectedModel} ${_selectedYear}',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _searchByLicensePlate() {
    // Implement license plate search logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Searching for Quartz oil for license plate: ${_licensePlateController.text}',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _searchOilByName(String oilName) {
    // Implement oil name search logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Searching for: $oilName',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }
}