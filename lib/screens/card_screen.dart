import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'visa_payment_screen.dart';
import 'mpesa_payment_screen.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCardType = 'virtual';
  String _selectedApplicationType = 'individual';
  double _cardBalance = 2500.0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        title: Text(
          'My Card',
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
          // Card Balance Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE60012), Color(0xFFB8000E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE60012).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TotalEnergies Card',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Available Balance',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'KSh ${_cardBalance.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _linkExistingCard,
                        icon: const Icon(Icons.link, color: Colors.white),
                        label: Text(
                          'Link Card',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                    'KSh ${_cardBalance.toStringAsFixed(2)}',
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
    final topUpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Top Up Card',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: topUpController,
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final amount = double.tryParse(topUpController.text);
                      if (amount != null && amount > 0) {
                        topUpController.dispose();
                        Navigator.pop(context);
                        _navigateToMpesaPayment(amount);
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
                      final amount = double.tryParse(topUpController.text);
                      if (amount != null && amount > 0) {
                        topUpController.dispose();
                        Navigator.pop(context);
                        _navigateToVisaPayment(amount);
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              topUpController.dispose();
              Navigator.pop(context);
            },
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _navigateToMpesaPayment(double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MpesaPaymentScreen(
          amount: amount,
          onPaymentSuccess: (phoneNumber) {
            setState(() {
              _cardBalance += amount;
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
        builder: (context) => VisaPaymentScreen(
          amount: amount,
          onPaymentSuccess: (cardNumber, expiryDate, cvv, cardHolderName) {
            setState(() {
              _cardBalance += amount;
              _transactions.insert(0, {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'type': 'topup',
                'amount': amount,
                'description': 'Card Top-up via Visa/Mastercard (****${cardNumber.substring(cardNumber.length - 4)})',
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

  void _manageCardSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Card settings feature coming soon!',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Help & Support feature coming soon!',
          style: GoogleFonts.poppins(),
        ),
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

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 450,
              child: Column(
                children: [
                  // Swipeable Card
                  Expanded(
                    child: PageView(
                      children: [
                        // Card Front
                        Container(
                          margin: const EdgeInsets.all(20),
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
                          margin: const EdgeInsets.all(20),
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
                              _saveCardDetails(
                                cardNumber,
                                expiryDate,
                                cvv,
                                cardHolderName,
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

  String _generateCardNumber() {
    // Generate a realistic-looking card number
    final random = DateTime.now().millisecondsSinceEpoch;
    final baseNumber = (random % 9000000000000000) + 1000000000000000;
    return baseNumber.toString().replaceAllMapped(
      RegExp(r'(\d{4})(?=\d)'),
      (Match match) => '${match.group(1)} ',
    );
  }

  String _generateExpiryDate() {
    final now = DateTime.now();
    final expiryYear = now.year + 3;
    final month = (now.month + 6) % 12;
    return '${month.toString().padLeft(2, '0')}/${expiryYear.toString().substring(2)}';
  }

  String _generateCVV() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return (random % 900 + 100).toString();
  }

  void _saveCardDetails(
    String cardNumber,
    String expiryDate,
    String cvv,
    String cardHolderName,
  ) {
    setState(() {
      _cardBalance = 0.0; // New card starts with zero balance
      _transactions.clear();
      _transactions.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': 'card_created',
        'amount': 0.0,
        'description': 'Virtual card created successfully',
        'date': DateTime.now().toIso8601String().split('T')[0],
        'time': '${DateTime.now().hour}:${DateTime.now().minute}',
        'status': 'completed',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Virtual card created and saved successfully!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Card',
          textColor: Colors.white,
          onPressed: () {
            // Switch to My Card tab
            _tabController.animateTo(0);
          },
        ),
      ),
    );
  }
}
