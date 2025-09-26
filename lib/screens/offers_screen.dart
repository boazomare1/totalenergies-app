import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _offers = [
    {
      'id': 'OFF-001',
      'title': 'Fuel Discount',
      'subtitle': 'Save 5% on every fuel purchase',
      'description': 'Get 5% discount on all fuel purchases when you use your TotalEnergies Card. Valid until end of month.',
      'discount': '5% OFF',
      'category': 'Fuel',
      'validUntil': '2024-01-31',
      'isActive': true,
      'image': 'assets/images/banner_quartz_oil_bg.png',
      'terms': 'Minimum purchase of KSh 1000. Not valid with other offers.',
    },
    {
      'id': 'OFF-002',
      'title': 'Car Wash Combo',
      'subtitle': 'Wash + Wax + Interior Clean',
      'description': 'Complete car care package at a special price. Includes exterior wash, waxing, and interior cleaning.',
      'discount': '30% OFF',
      'category': 'Services',
      'validUntil': '2024-02-15',
      'isActive': true,
      'image': 'assets/images/banner_enjoy_bg.png',
      'terms': 'Valid at participating stations. Book in advance.',
    },
    {
      'id': 'OFF-003',
      'title': 'KFC Meal Deal',
      'subtitle': 'Buy 2 Get 1 Free',
      'description': 'Enjoy your favorite KFC meal with this amazing buy 2 get 1 free offer at TotalEnergies stations.',
      'discount': '33% OFF',
      'category': 'Food',
      'validUntil': '2024-01-25',
      'isActive': true,
      'image': 'assets/images/banner_kfc_bg.png',
      'terms': 'Valid on selected meals. Dine-in only.',
    },
    {
      'id': 'OFF-004',
      'title': 'Quartz Oil Change',
      'subtitle': 'Premium Oil + Filter Change',
      'description': 'Complete oil change service with premium Quartz oil and new filter. Keep your engine running smoothly.',
      'discount': '20% OFF',
      'category': 'Services',
      'validUntil': '2024-02-28',
      'isActive': true,
      'image': 'assets/images/banner_quartz_oil_bg.png',
      'terms': 'Includes labor and disposal. Valid for all vehicle types.',
    },
    {
      'id': 'OFF-005',
      'title': 'Weekend Special',
      'subtitle': 'Double Points Weekend',
      'description': 'Earn double loyalty points on all purchases during weekends. Perfect time to stock up!',
      'discount': '2X POINTS',
      'category': 'Loyalty',
      'validUntil': '2024-01-28',
      'isActive': true,
      'image': 'assets/images/banner_card_bg.png',
      'terms': 'Valid every Saturday and Sunday. Points credited within 24 hours.',
    },
    {
      'id': 'OFF-006',
      'title': 'New Customer Welcome',
      'subtitle': 'First Purchase Bonus',
      'description': 'Welcome to TotalEnergies! Get KSh 500 bonus credit on your first purchase over KSh 2000.',
      'discount': 'KSh 500',
      'category': 'Welcome',
      'validUntil': '2024-03-31',
      'isActive': false,
      'image': 'assets/images/banner_gas_delivery_bg.png',
      'terms': 'New customers only. One-time use. Cannot be combined with other offers.',
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

  List<Map<String, dynamic>> get _filteredOffers {
    if (_selectedCategory == 'All') return _offers;
    return _offers.where((offer) => offer['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Offers & Promotions',
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
            onPressed: _searchOffers,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Expired'),
            Tab(text: 'My Coupons'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveOffers(),
          _buildExpiredOffers(),
          _buildMyCoupons(),
        ],
      ),
    );
  }

  Widget _buildActiveOffers() {
    final activeOffers = _filteredOffers.where((offer) => offer['isActive']).toList();
    
    return Column(
      children: [
        // Category Filter
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('All'),
                const SizedBox(width: 8),
                _buildCategoryChip('Fuel'),
                const SizedBox(width: 8),
                _buildCategoryChip('Services'),
                const SizedBox(width: 8),
                _buildCategoryChip('Food'),
                const SizedBox(width: 8),
                _buildCategoryChip('Loyalty'),
                const SizedBox(width: 8),
                _buildCategoryChip('Welcome'),
              ],
            ),
          ),
        ),
        
        // Offers List
        Expanded(
          child: activeOffers.isEmpty
              ? _buildEmptyState('No active offers', 'Check back later for new promotions')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeOffers.length,
                  itemBuilder: (context, index) {
                    final offer = activeOffers[index];
                    return _buildOfferCard(offer);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildExpiredOffers() {
    final expiredOffers = _filteredOffers.where((offer) => !offer['isActive']).toList();
    
    return expiredOffers.isEmpty
        ? _buildEmptyState('No expired offers', 'Your expired offers will appear here')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: expiredOffers.length,
            itemBuilder: (context, index) {
              final offer = expiredOffers[index];
              return _buildOfferCard(offer, isExpired: true);
            },
          );
  }

  Widget _buildMyCoupons() {
    return _buildEmptyState('No coupons yet', 'Your saved coupons will appear here');
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE60012) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer, {bool isExpired = false}) {
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
          // Offer Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(offer['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Dark overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
                
                // Discount badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isExpired ? Colors.grey[600] : const Color(0xFFE60012),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      offer['discount'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                // Category badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      offer['category'],
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                // Expired overlay
                if (isExpired)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'EXPIRED',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Offer Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  offer['subtitle'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  offer['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Validity
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Valid until ${offer['validUntil']}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewOfferDetails(offer),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isExpired ? null : () => _claimOffer(offer),
                        icon: const Icon(Icons.local_offer, size: 16),
                        label: const Text('Claim'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _searchOffers() {
    showSearch(
      context: context,
      delegate: OfferSearchDelegate(_offers),
    );
  }

  void _viewOfferDetails(Map<String, dynamic> offer) {
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
                    'Offer Details',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Offer Image
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(offer['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Title and Discount
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            offer['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE60012),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            offer['discount'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      offer['subtitle'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Terms and Conditions
                    Text(
                      'Terms & Conditions',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer['terms'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Validity
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.grey[600]),
                          const SizedBox(width: 12),
                          Text(
                            'Valid until ${offer['validUntil']}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Action Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: offer['isActive'] ? () => _claimOffer(offer) : null,
                  icon: const Icon(Icons.local_offer),
                  label: Text(
                    offer['isActive'] ? 'Claim Offer' : 'Offer Expired',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: offer['isActive'] ? const Color(0xFFE60012) : Colors.grey[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _claimOffer(Map<String, dynamic> offer) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Offer "${offer['title']}" claimed successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to my coupons
            _tabController.animateTo(2);
          },
        ),
      ),
    );
  }
}

class OfferSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> offers;

  OfferSearchDelegate(this.offers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredOffers = offers.where((offer) {
      return offer['title'].toLowerCase().contains(query.toLowerCase()) ||
             offer['description'].toLowerCase().contains(query.toLowerCase()) ||
             offer['category'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredOffers.length,
      itemBuilder: (context, index) {
        final offer = filteredOffers[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFE60012).withValues(alpha: 0.1),
            child: Icon(
              Icons.local_offer,
              color: const Color(0xFFE60012),
            ),
          ),
          title: Text(
            offer['title'],
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            offer['subtitle'],
            style: GoogleFonts.poppins(),
          ),
          trailing: Text(
            offer['discount'],
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE60012),
            ),
          ),
          onTap: () {
            close(context, offer);
          },
        );
      },
    );
  }
}