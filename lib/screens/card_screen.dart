import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_payment_screen.dart';
import 'mpesa_payment_screen.dart';
import 'bank_transfer_screen.dart';
import 'enhanced_station_locator_screen.dart';
import '../services/auth_service.dart';
import '../services/hive_database_service.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCardType = 'virtual';
  String _selectedApplicationType = 'individual';
  double _cardBalance = 0.0;
  bool _hideBalance = false;
  bool _isLoggedIn = false;
  String _userName = 'Guest';
  bool _showCardBack = false;
  String _cardNumber = '';
  String _cvv = '';
  String _expiryDate = '';
  final List<Map<String, dynamic>> _transactions = [];
  final TextEditingController _topUpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _regNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCardData();
    _checkAuthStatus();
    _loadUserData();
  }

  void _loadUserData() {
    final user = AuthService.getCurrentUser();
    print('Loading user data: $user');
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      print(
        'Loaded user data - Name: ${user.name}, Email: ${user.email}, Phone: ${user.phone}',
      );
    } else {
      print('No user data found');
    }
  }

  Future<void> _updateUserBalance(double newBalance) async {
    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(cardBalance: newBalance);
        await HiveDatabaseService.updateUser(updatedUser);
        // Update the cached user in AuthService
        await AuthService.updateCurrentUser(updatedUser);
        setState(() {
          _cardBalance = newBalance;
        });
      }
    } catch (e) {
      print('Error updating user balance: $e');
    }
  }

  // Generate a unique card number based on user ID
  String _generateCardNumber() {
    final currentUser = AuthService.getCurrentUser();
    if (currentUser == null) return '4532 1234 5678 9012';

    // Use user ID to generate a consistent card number
    final userId = currentUser.id;
    final hash = userId.hashCode.abs();

    // Generate a 16-digit card number
    final cardNumber =
        '4532 ${(hash % 10000).toString().padLeft(4, '0')} ${(hash % 10000).toString().padLeft(4, '0')} ${(hash % 10000).toString().padLeft(4, '0')}';
    return cardNumber;
  }

  // Generate a unique CVV based on user ID
  String _generateCVV() {
    final currentUser = AuthService.getCurrentUser();
    if (currentUser == null) return '123';

    final userId = currentUser.id;
    final hash = userId.hashCode.abs();
    return (hash % 1000).toString().padLeft(3, '0');
  }

  // Generate expiry date (3 years from now)
  String _generateExpiryDate() {
    final now = DateTime.now();
    final expiry = DateTime(now.year + 3, now.month, now.day);
    return '${expiry.month.toString().padLeft(2, '0')}/${expiry.year.toString().substring(2)}';
  }

  // Save card details to Hive
  Future<void> _saveCardDetails() async {
    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          cardNumber: _cardNumber,
          cvv: _cvv,
          expiryDate: _expiryDate,
        );
        await HiveDatabaseService.updateUser(updatedUser);
        // Update the cached user in AuthService
        await AuthService.updateCurrentUser(updatedUser);
      }
    } catch (e) {
      print('Error saving card details: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _topUpController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _companyController.dispose();
    _regNumberController.dispose();
    super.dispose();
  }

  void _loadCardData() {
    setState(() {
      _transactions.addAll([
        {
          'id': '1',
          'type': 'fuel',
          'amount': -500.0,
          'description': 'Fuel Purchase - Westlands Station',
          'date': '2024-01-15',
          'time': '14:30',
          'status': 'completed',
        },
        {
          'id': '2',
          'type': 'topup',
          'amount': 1000.0,
          'description': 'Card Top-up via M-Pesa',
          'date': '2024-01-14',
          'time': '09:15',
          'status': 'completed',
        },
        {
          'id': '3',
          'type': 'fuel',
          'amount': -300.0,
          'description': 'Fuel Purchase - Karen Station',
          'date': '2024-01-13',
          'time': '16:45',
          'status': 'completed',
        },
      ]);
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await AuthService.isLoggedIn();
      final currentUser = AuthService.getCurrentUser();

      setState(() {
        _isLoggedIn = isLoggedIn;
        _userName = currentUser?.name ?? 'Guest';
        _cardBalance = currentUser?.cardBalance ?? 0.0;

        // Load or generate card details
        if (currentUser != null) {
          _cardNumber =
              currentUser.cardNumber.isNotEmpty
                  ? currentUser.cardNumber
                  : _generateCardNumber();
          _cvv = currentUser.cvv.isNotEmpty ? currentUser.cvv : _generateCVV();
          _expiryDate =
              currentUser.expiryDate.isNotEmpty
                  ? currentUser.expiryDate
                  : _generateExpiryDate();

          // Save generated card details if they were empty
          if (currentUser.cardNumber.isEmpty ||
              currentUser.cvv.isEmpty ||
              currentUser.expiryDate.isEmpty) {
            _saveCardDetails();
          }
        } else {
          // Default values for guest users
          _cardNumber = '4532 1234 5678 9012';
          _cvv = '123';
          _expiryDate = '12/25';
        }
      });
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        title: Text(
          _isLoggedIn ? 'My Card - $_userName' : 'My Card',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'My Card'),
            Tab(text: 'Apply'),
            Tab(text: 'Transactions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyCardTab(),
          _buildApplyTab(),
          _buildTransactionsTab(),
        ],
      ),
    );
  }

  Widget _buildMyCardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Realistic Card Design
          _buildRealisticCard(),

          const SizedBox(height: 16),

          // Card Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _topUpCard,
                  icon: const Icon(Icons.add, color: Color(0xFFE60012)),
                  label: Text(
                    'Top Up',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE60012),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _linkExistingCard,
                  icon: const Icon(Icons.link, color: Color(0xFFE60012)),
                  label: Text(
                    'Link Card',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE60012),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE60012)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Check Balance',
                  onTap: _checkBalance,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.history,
                  title: 'Transaction History',
                  onTap: () => _tabController.animateTo(2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.settings,
                  title: 'Card Settings',
                  onTap: _manageCardSettings,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: _showHelp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Application Type Selection
          Text(
            'Application Type',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildApplicationTypeCard(
                  title: 'Individual',
                  subtitle: 'Personal use',
                  icon: Icons.person,
                  isSelected: _selectedApplicationType == 'individual',
                  onTap:
                      () => setState(
                        () => _selectedApplicationType = 'individual',
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildApplicationTypeCard(
                  title: 'Corporate',
                  subtitle: 'Business use',
                  icon: Icons.business,
                  isSelected: _selectedApplicationType == 'corporate',
                  onTap:
                      () => setState(
                        () => _selectedApplicationType = 'corporate',
                      ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Card Type Selection
          Text(
            'Card Type',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildCardTypeCard(
                  title: 'Virtual Card',
                  subtitle: 'Digital only',
                  icon: Icons.phone_android,
                  isSelected: _selectedCardType == 'virtual',
                  onTap: () => setState(() => _selectedCardType = 'virtual'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCardTypeCard(
                  title: 'Physical Card',
                  subtitle: 'Delivered to you',
                  icon: Icons.credit_card,
                  isSelected: _selectedCardType == 'physical',
                  onTap: () => setState(() => _selectedCardType = 'physical'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Application Form
          Text(
            'Application Details',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedApplicationType == 'corporate') ...[
                  TextField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: 'Company Name',
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _regNumberController,
                    decoration: InputDecoration(
                      labelText: 'Company Registration Number',
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'ID Number',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitApplication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE60012),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _selectedCardType == 'virtual'
                          ? 'Create Virtual Card'
                          : 'Submit Application',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  Widget _buildTransactionsTab() {
    return Column(
      children: [
        // Balance Summary
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Current Balance',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _hideBalance
                        ? '••••••••'
                        : 'KSh ${_cardBalance.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFE60012),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(height: 40, width: 1, color: Colors.grey[300]),
              Column(
                children: [
                  Text(
                    'This Month',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'KSh ${_getMonthlySpending().toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[800],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Transactions List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              return _buildTransactionCard(transaction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRealisticCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showCardBack = !_showCardBack;
        });
      },
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE60012), Color(0xFFB8000E), Color(0xFF8B0000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE60012).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: _showCardBack ? _buildCardBack() : _buildCardFront(),
      ),
    );
  }

  Widget _buildCardFront() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with TotalEnergies logo and chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TotalEnergies Logo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'TOTALENERGIES',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              // Chip
              Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.amber[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'CHIP',
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Card Number
          Text(
            _hideBalance ? '•••• •••• •••• ••••' : _cardNumber,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          // Bottom row with name and expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Card Holder Name
              if (_isLoggedIn) ...[
                Expanded(
                  child: Text(
                    _userName.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              // Expiry Date
              Text(
                _expiryDate,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Balance
          Row(
            children: [
              Text(
                'Balance: ',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
              ),
              Text(
                _hideBalance
                    ? '••••••••'
                    : 'KSh ${_cardBalance.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_isLoggedIn) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hideBalance = !_hideBalance;
                    });
                  },
                  child: Icon(
                    _hideBalance ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          // Magnetic strip
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          // CVV section
          Row(
            children: [
              Container(
                width: 200,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        'CVV: ',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _hideBalance ? '•••' : _cvv,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Signature strip
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                'Authorized Signature',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Tap to flip text
          Center(
            child: Text(
              'Tap to flip card',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFE60012), size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFE60012).withValues(alpha: 0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE60012) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE60012) : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFFE60012) : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTypeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFE60012).withValues(alpha: 0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE60012) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE60012) : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFFE60012) : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isDebit = transaction['amount'] < 0;
    final amount = transaction['amount'].abs();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isDebit
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDebit ? Icons.arrow_upward : Icons.arrow_downward,
              color: isDebit ? Colors.red : Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction['date']} at ${transaction['time']}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isDebit ? '-' : '+'}KSh ${amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDebit ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  double _getMonthlySpending() {
    return _transactions
        .where((t) => t['amount'] < 0)
        .fold(0.0, (sum, t) => sum + t['amount'].abs());
  }

  void _topUpCard() {
    showDialog(
      context: context,
      builder:
          (context) => _TopUpDialog(
            onMpesaPayment: _navigateToMpesaPayment,
            onVisaPayment: _navigateToVisaPayment,
            onBankTransferPayment: _navigateToBankTransferPayment,
          ),
    );
  }

  void _navigateToMpesaPayment(double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MpesaPaymentScreen(
              amount: amount,
              onPaymentSuccess: (phoneNumber) async {
                final newBalance = _cardBalance + amount;
                await _updateUserBalance(newBalance);
                setState(() {
                  _transactions.insert(0, {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'type': 'topup',
                    'amount': amount,
                    'description': 'Card Top-up via M-Pesa ($phoneNumber)',
                    'date': DateTime.now().toIso8601String().split('T')[0],
                    'time': '${DateTime.now().hour}:${DateTime.now().minute}',
                    'status': 'completed',
                  });
                });
              },
            ),
      ),
    );
  }

  void _navigateToVisaPayment(double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VisaPaymentScreen(
              amount: amount,
              onPaymentSuccess: (
                cardNumber,
                expiryDate,
                cvv,
                cardHolderName,
              ) async {
                final newBalance = _cardBalance + amount;
                await _updateUserBalance(newBalance);
                setState(() {
                  _transactions.insert(0, {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'type': 'topup',
                    'amount': amount,
                    'description':
                        'Card Top-up via Visa/Mastercard (****${cardNumber.substring(cardNumber.length - 4)})',
                    'date': DateTime.now().toIso8601String().split('T')[0],
                    'time': '${DateTime.now().hour}:${DateTime.now().minute}',
                    'status': 'completed',
                  });
                });
              },
            ),
      ),
    );
  }

  void _navigateToBankTransferPayment(double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BankTransferScreen(amount: amount),
      ),
    ).then((success) async {
      if (success == true) {
        final newBalance = _cardBalance + amount;
        await _updateUserBalance(newBalance);
        setState(() {
          _transactions.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'type': 'topup',
            'amount': amount,
            'description': 'Card Top-up via Bank Transfer',
            'date': DateTime.now().toIso8601String().split('T')[0],
            'time': '${DateTime.now().hour}:${DateTime.now().minute}',
            'status': 'completed',
          });
        });
      }
    });
  }

  void _linkExistingCard() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Link Existing Card',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Card Number',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Card PIN',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: GoogleFonts.poppins()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Card linked successfully!',
                                style: GoogleFonts.poppins(),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE60012),
                        ),
                        child: Text(
                          'Link Card',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void _checkBalance() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Card Balance',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Your current balance is KSh ${_cardBalance.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60012),
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  // Helper methods for settings
  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE60012)),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(color: Colors.grey[600]),
      ),
      trailing:
          onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  // Helper methods for help
  Widget _buildHelpSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildHelpItem(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFE60012)),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(color: Colors.grey[600]),
      ),
      trailing:
          onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  // Settings action methods
  void _showChangePinDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Change PIN',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'This feature will be available soon. You can change your PIN at any TotalEnergies station.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
                ),
              ),
            ],
          ),
    );
  }

  void _showTransactionLimitsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Transaction Limits',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Set your daily spending limits. This feature will be available in the next update.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
                ),
              ),
            ],
          ),
    );
  }

  void _showBlockCardDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Block Card',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Are you sure you want to temporarily block your card? You can unblock it anytime.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Card blocked successfully',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: Text(
                  'Block',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Notification Settings',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Manage your notification preferences. This feature will be available soon.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
                ),
              ),
            ],
          ),
    );
  }

  // Help action methods
  void _callSupport() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Call Support',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Call our support team at +254 700 000 000 for immediate assistance.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening phone dialer...',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFFE60012),
                    ),
                  );
                },
                child: Text(
                  'Call',
                  style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
                ),
              ),
            ],
          ),
    );
  }

  void _emailSupport() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Email Support',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Send us an email at support@totalenergies.co.ke and we\'ll get back to you within 24 hours.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.poppins()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening email client...',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFFE60012),
                    ),
                  );
                },
                child: Text(
                  'Email',
                  style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
                ),
              ),
            ],
          ),
    );
  }

  void _openLiveChat() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Live Chat',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Live chat support is available 24/7. This feature will be available in the next update.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(color: const Color(0xFFE60012)),
                ),
              ),
            ],
          ),
    );
  }

  void _findNearestStation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedStationLocatorScreen(),
      ),
    );
  }

  void _showFAQ(String question) {
    String answer = '';
    switch (question) {
      case 'What is a TotalEnergies card?':
        answer =
            'A TotalEnergies card is a prepaid card that allows you to pay for fuel and services at TotalEnergies stations. It offers convenience, security, and rewards.';
        break;
      case 'How do I activate my card?':
        answer =
            'You can activate your card at any TotalEnergies station by presenting your card and ID. The staff will help you complete the activation process.';
        break;
      case 'What are the fees?':
        answer =
            'There are no monthly fees. Transaction fees are minimal and vary by service. Check the fee schedule at any station for detailed information.';
        break;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              question,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(answer, style: GoogleFonts.poppins()),
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

  void _manageCardSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 5,
                      width: 50,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Card Settings',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Card Information
                            _buildSettingsSection('Card Information', [
                              _buildSettingsItem(
                                'Card Number',
                                '**** **** **** 1234',
                                Icons.credit_card,
                              ),
                              _buildSettingsItem(
                                'Card Type',
                                'TotalEnergies Premium',
                                Icons.card_membership,
                              ),
                              _buildSettingsItem(
                                'Expiry Date',
                                '12/25',
                                Icons.calendar_today,
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Security Settings
                            _buildSettingsSection('Security', [
                              _buildSettingsItem(
                                'Change PIN',
                                'Update your card PIN',
                                Icons.lock,
                                onTap: () => _showChangePinDialog(),
                              ),
                              _buildSettingsItem(
                                'Transaction Limits',
                                'Set daily spending limits',
                                Icons.speed,
                                onTap: () => _showTransactionLimitsDialog(),
                              ),
                              _buildSettingsItem(
                                'Block/Unblock Card',
                                'Temporarily disable your card',
                                Icons.block,
                                onTap: () => _showBlockCardDialog(),
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Notifications
                            _buildSettingsSection('Notifications', [
                              _buildSettingsItem(
                                'Transaction Alerts',
                                'Get notified of all transactions',
                                Icons.notifications,
                                onTap: () => _showNotificationSettings(),
                              ),
                              _buildSettingsItem(
                                'Low Balance Alerts',
                                'Alert when balance is low',
                                Icons.warning,
                                onTap: () => _showNotificationSettings(),
                              ),
                            ]),
                          ],
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

  void _showHelp() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 5,
                      width: 50,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Help & Support',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Quick Help Topics
                            _buildHelpSection('Quick Help', [
                              _buildHelpItem(
                                'How to check balance',
                                'View your current card balance and transaction history',
                                Icons.account_balance_wallet,
                              ),
                              _buildHelpItem(
                                'How to top up',
                                'Add funds to your TotalEnergies card',
                                Icons.add_circle,
                              ),
                              _buildHelpItem(
                                'How to use at stations',
                                'Pay for fuel and services using your card',
                                Icons.local_gas_station,
                              ),
                              _buildHelpItem(
                                'Lost or stolen card',
                                'Report and block your card immediately',
                                Icons.report_problem,
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // Contact Support
                            _buildHelpSection('Contact Support', [
                              _buildHelpItem(
                                'Call Support',
                                '+254 700 000 000',
                                Icons.phone,
                                onTap: () => _callSupport(),
                              ),
                              _buildHelpItem(
                                'Email Support',
                                'support@totalenergies.co.ke',
                                Icons.email,
                                onTap: () => _emailSupport(),
                              ),
                              _buildHelpItem(
                                'Live Chat',
                                'Chat with our support team',
                                Icons.chat,
                                onTap: () => _openLiveChat(),
                              ),
                              _buildHelpItem(
                                'Visit Station',
                                'Find nearest TotalEnergies station',
                                Icons.location_on,
                                onTap: () => _findNearestStation(),
                              ),
                            ]),

                            const SizedBox(height: 20),

                            // FAQ
                            _buildHelpSection('Frequently Asked Questions', [
                              _buildHelpItem(
                                'What is a TotalEnergies card?',
                                'A prepaid card for fuel and services',
                                Icons.help_outline,
                                onTap:
                                    () => _showFAQ(
                                      'What is a TotalEnergies card?',
                                    ),
                              ),
                              _buildHelpItem(
                                'How do I activate my card?',
                                'Activate your card at any station',
                                Icons.help_outline,
                                onTap:
                                    () =>
                                        _showFAQ('How do I activate my card?'),
                              ),
                              _buildHelpItem(
                                'What are the fees?',
                                'View all card-related fees',
                                Icons.help_outline,
                                onTap: () => _showFAQ('What are the fees?'),
                              ),
                            ]),
                          ],
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

  void _submitApplication() {
    if (_selectedCardType == 'virtual') {
      _createVirtualCard();
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                'Application Submitted',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: Text(
                'Your physical card application has been submitted successfully. You will receive a notification once it\'s processed and delivered.',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60012),
                  ),
                  child: Text(
                    'OK',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
      );
    }
  }

  void _createVirtualCard() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE60012)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Creating your virtual card...',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please wait while we generate your card details',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
    );

    // Simulate card creation process
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close loading dialog
      _showVirtualCard();
    });
  }

  void _showVirtualCard() {
    final cardNumber = _generateCardNumber();
    final expiryDate = _generateExpiryDate();
    final cvv = _generateCVV();
    final cardHolderName =
        _nameController.text.isNotEmpty ? _nameController.text : 'Card Holder';

    print(
      'Virtual card generation - Name controller: "${_nameController.text}", Card holder: "$cardHolderName"',
    );

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 350,
              height: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Swipeable Card
                  Container(
                    height: 200,
                    child: PageView(
                      children: [
                        // Card Front
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE60012), Color(0xFFB8000E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE60012,
                                ).withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // TotalEnergies Logo
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'assets/images/totalenergies_logo_white.png',
                                    height: 20,
                                    width: 40,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        'TOTAL',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Card Number
                              Positioned(
                                bottom: 60,
                                left: 20,
                                right: 20,
                                child: Text(
                                  cardNumber,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              // Card Holder Name
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Text(
                                  cardHolderName.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Expiry Date
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: Text(
                                  expiryDate,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Card Back
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Magnetic strip
                              Positioned(
                                top: 20,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 30,
                                  color: Colors.black,
                                ),
                              ),
                              // CVV
                              Positioned(
                                top: 70,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'CVV: $cvv',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              // Lost Card Information
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'If this card is lost or stolen:',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Call: +254 700 000 000',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      'Email: support@totalenergies.co.ke',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Text(
                                      'Visit: Any TotalEnergies Station',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Swipe indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Swipe to see card back',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE60012)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Close',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFE60012),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Card details are automatically saved when generated
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Card details saved successfully!',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE60012),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Save Card',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
          ),
    );
  }
}

class _TopUpDialog extends StatefulWidget {
  final Function(double) onMpesaPayment;
  final Function(double) onVisaPayment;
  final Function(double) onBankTransferPayment;

  const _TopUpDialog({
    required this.onMpesaPayment,
    required this.onVisaPayment,
    required this.onBankTransferPayment,
  });

  @override
  State<_TopUpDialog> createState() => _TopUpDialogState();
}

class _TopUpDialogState extends State<_TopUpDialog> {
  final _topUpController = TextEditingController();

  @override
  void dispose() {
    _topUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Top Up Card',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _topUpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (KSh)',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Choose Payment Method',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final amount = double.tryParse(_topUpController.text);
                          if (amount != null && amount > 0) {
                            Navigator.pop(context);
                            widget.onMpesaPayment(amount);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please enter a valid amount',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.phone_android, size: 20),
                        label: Text('M-Pesa', style: GoogleFonts.poppins()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final amount = double.tryParse(_topUpController.text);
                          if (amount != null && amount > 0) {
                            Navigator.pop(context);
                            widget.onVisaPayment(amount);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please enter a valid amount',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.credit_card, size: 20),
                        label: Text('Visa', style: GoogleFonts.poppins()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE60012),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final amount = double.tryParse(_topUpController.text);
                      if (amount != null && amount > 0) {
                        Navigator.pop(context);
                        widget.onBankTransferPayment(amount);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter a valid amount',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.account_balance, size: 20),
                    label: Text('Bank Transfer', style: GoogleFonts.poppins()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.poppins()),
        ),
      ],
    );
  }
}
