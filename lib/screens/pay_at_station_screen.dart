import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class PayAtStationScreen extends StatefulWidget {
  const PayAtStationScreen({super.key});

  @override
  State<PayAtStationScreen> createState() => _PayAtStationScreenState();
}

class _PayAtStationScreenState extends State<PayAtStationScreen> {
  String? _selectedPaymentType;
  String? _selectedStation;
  String? _selectedPaymentMethod;
  double _amount = 0.0;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final List<Map<String, dynamic>> _paymentTypes = [
    {
      'id': 'fuel',
      'title': 'Pay for Fuel',
      'subtitle': 'Pay for your fuel purchase',
      'icon': Icons.local_gas_station,
      'color': Colors.green,
    },
    {
      'id': 'gas',
      'title': 'Pay for Total Gas',
      'subtitle': 'Pay for gas cylinder & accessories',
      'icon': Icons.gas_meter,
      'color': Colors.blue,
    },
    {
      'id': 'lubricants',
      'title': 'Pay for Lubricants',
      'subtitle': 'Pay for Quartz oil & lubricants',
      'icon': Icons.oil_barrel,
      'color': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> _stations = [
    {
      'id': '1',
      'name': 'TotalEnergies Westlands',
      'address': 'Westlands Road, Nairobi',
      'distance': '2.3 km',
      'isOpen': true,
    },
    {
      'id': '2',
      'name': 'TotalEnergies Karen',
      'address': 'Karen Shopping Centre, Nairobi',
      'distance': '4.7 km',
      'isOpen': true,
    },
    {
      'id': '3',
      'name': 'TotalEnergies Thika Road',
      'address': 'Thika Road, Nairobi',
      'distance': '6.2 km',
      'isOpen': false,
    },
    {
      'id': '4',
      'name': 'TotalEnergies Mombasa Road',
      'address': 'Mombasa Road, Nairobi',
      'distance': '8.1 km',
      'isOpen': true,
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cash',
      'title': 'Cash',
      'subtitle': 'Pay with cash at station',
      'icon': Icons.money,
      'color': Colors.green,
    },
    {
      'id': 'mpesa',
      'title': 'M-Pesa',
      'subtitle': 'Pay via M-Pesa',
      'icon': Icons.phone_android,
      'color': Colors.orange,
    },
    {
      'id': 'visa',
      'title': 'Visa',
      'subtitle': 'Pay with Visa card',
      'icon': Icons.credit_card,
      'color': Colors.blue,
    },
    {
      'id': 'mastercard',
      'title': 'Mastercard',
      'subtitle': 'Pay with Mastercard',
      'icon': Icons.credit_card,
      'color': Colors.red,
    },
    {
      'id': 'total_card',
      'title': 'TotalEnergies Card',
      'subtitle': 'Pay with your TotalEnergies card',
      'icon': Icons.card_membership,
      'color': const Color(0xFFE60012),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pay at Station',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Type Selection
            Text(
              'What would you like to pay for?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ..._paymentTypes.map((type) => _buildPaymentTypeCard(type)),
            const SizedBox(height: 24),

            // Station Selection
            if (_selectedPaymentType != null) ...[
              Text(
                'Select Station',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ..._stations.map((station) => _buildStationCard(station)),
              const SizedBox(height: 24),
            ],

            // Amount Input
            if (_selectedStation != null) ...[
              Text(
                'Enter Amount',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (KSh)',
                    labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                    border: InputBorder.none,
                    prefixText: 'KSh ',
                    prefixStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE60012),
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      _amount = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Payment Method Selection
            if (_amount > 0) ...[
              Text(
                'Payment Method',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ..._paymentMethods.map(
                (method) => _buildPaymentMethodCard(method),
              ),
              const SizedBox(height: 24),
            ],

            // Phone Number for M-Pesa
            if (_selectedPaymentMethod == 'mpesa') ...[
              Text(
                'M-Pesa Phone Number',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                    border: InputBorder.none,
                    prefixText: '+254 ',
                    prefixStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE60012),
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Proceed Button
            if (_selectedPaymentMethod != null && _amount > 0) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60012),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Proceed to Payment',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTypeCard(Map<String, dynamic> type) {
    final isSelected = _selectedPaymentType == type['id'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPaymentType = type['id'];
              _selectedStation = null;
              _selectedPaymentMethod = null;
              _amount = 0.0;
              _amountController.clear();
              _phoneController.clear();
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? type['color'] : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: type['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(type['icon'], color: type['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type['subtitle'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: type['color'], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStationCard(Map<String, dynamic> station) {
    final isSelected = _selectedStation == station['id'];
    final isOpen = station['isOpen'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap:
              isOpen
                  ? () {
                    setState(() {
                      _selectedStation = station['id'];
                      _selectedPaymentMethod = null;
                      _amount = 0.0;
                      _amountController.clear();
                      _phoneController.clear();
                    });
                  }
                  : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFFE60012) : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        isOpen
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: isOpen ? Colors.green : Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isOpen ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        station['address'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isOpen ? Colors.grey[600] : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.directions,
                            size: 16,
                            color: isOpen ? Colors.grey[600] : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            station['distance'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: isOpen ? Colors.grey[600] : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isOpen ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isOpen ? 'Open' : 'Closed',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFFE60012),
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPaymentMethod = method['id'];
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? method['color'] : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: method['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(method['icon'], color: method['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method['subtitle'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: method['color'], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _proceedToPayment() {
    if (_selectedPaymentType == null ||
        _selectedStation == null ||
        _amount <= 0) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaymentConfirmationScreen(
              paymentType: _paymentTypes.firstWhere(
                (type) => type['id'] == _selectedPaymentType,
              ),
              station: _stations.firstWhere(
                (station) => station['id'] == _selectedStation,
              ),
              paymentMethod: _paymentMethods.firstWhere(
                (method) => method['id'] == _selectedPaymentMethod,
              ),
              amount: _amount,
              phoneNumber: _phoneController.text,
            ),
      ),
    );
  }
}

class PaymentConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> paymentType;
  final Map<String, dynamic> station;
  final Map<String, dynamic> paymentMethod;
  final double amount;
  final String phoneNumber;

  const PaymentConfirmationScreen({
    super.key,
    required this.paymentType,
    required this.station,
    required this.paymentMethod,
    required this.amount,
    required this.phoneNumber,
  });

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Payment Confirmation',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Type
                  _buildSummaryRow(
                    'Payment Type',
                    widget.paymentType['title'],
                    widget.paymentType['icon'],
                    widget.paymentType['color'],
                  ),
                  const SizedBox(height: 12),

                  // Station
                  _buildSummaryRow(
                    'Station',
                    widget.station['name'],
                    Icons.location_on,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),

                  // Amount
                  _buildSummaryRow(
                    'Amount',
                    'KSh ${widget.amount.toStringAsFixed(2)}',
                    Icons.money,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),

                  // Payment Method
                  _buildSummaryRow(
                    'Payment Method',
                    widget.paymentMethod['title'],
                    widget.paymentMethod['icon'],
                    widget.paymentMethod['color'],
                  ),

                  if (widget.paymentMethod['id'] == 'mpesa' &&
                      widget.phoneNumber.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Phone Number',
                      '+254 ${widget.phoneNumber}',
                      Icons.phone,
                      Colors.orange,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Terms and Conditions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Important Information',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Payment will be processed at the selected station\n'
                    '• Please arrive at the station within 30 minutes\n'
                    '• Show your payment confirmation to the attendant\n'
                    '• Keep your receipt for your records',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60012),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isProcessing
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Processing...',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                        : Text(
                          'Pay Now',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      // Navigate to receipt screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => PaymentReceiptScreen(
                paymentType: widget.paymentType,
                station: widget.station,
                paymentMethod: widget.paymentMethod,
                amount: widget.amount,
                phoneNumber: widget.phoneNumber,
                transactionId: _generateTransactionId(),
              ),
        ),
      );
    }
  }

  String _generateTransactionId() {
    final now = DateTime.now();
    return 'TXN${now.millisecondsSinceEpoch.toString().substring(8)}';
  }
}

class PaymentReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> paymentType;
  final Map<String, dynamic> station;
  final Map<String, dynamic> paymentMethod;
  final double amount;
  final String phoneNumber;
  final String transactionId;

  const PaymentReceiptScreen({
    super.key,
    required this.paymentType,
    required this.station,
    required this.paymentMethod,
    required this.amount,
    required this.phoneNumber,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Payment Receipt',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Success Message
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600], size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Payment Successful!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your payment has been processed successfully',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.green[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Receipt
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/totalenergies_logo.png',
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              'TOTALENERGIES',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFE60012),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'PAYMENT RECEIPT',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Transaction ID: $transactionId',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: ${_formatDate(DateTime.now())}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Payment Details
                  _buildReceiptRow('Payment Type', paymentType['title']),
                  _buildReceiptRow('Station', station['name']),
                  _buildReceiptRow('Address', station['address']),
                  _buildReceiptRow('Payment Method', paymentMethod['title']),
                  if (paymentMethod['id'] == 'mpesa' && phoneNumber.isNotEmpty)
                    _buildReceiptRow('Phone Number', '+254 $phoneNumber'),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'KSh ${amount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE60012),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SMS Notification
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.sms, color: Colors.blue[600], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'SMS confirmation sent to your phone',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.blue[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Share receipt functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Receipt sharing feature coming soon!',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFFE60012)),
                    ),
                    child: Text(
                      'Share Receipt',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE60012),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/main',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE60012),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
