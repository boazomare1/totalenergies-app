import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentStep = 0;
  
  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  
  // Payment details
  String _selectedPaymentMethod = 'mpesa';
  String _selectedDeliveryTime = 'asap';
  String _selectedDeliveryType = 'home';
  
  // Order summary
  final double _deliveryFee = 200.0;
  final double _serviceFee = 50.0;
  double _tax = 0.0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _calculateTax();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  void _calculateTax() {
    _tax = (widget.totalAmount + _deliveryFee + _serviceFee) * 0.16; // 16% VAT
  }

  double get _grandTotal => widget.totalAmount + _deliveryFee + _serviceFee + _tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          onTap: (index) {
            setState(() {
              _currentStep = index;
            });
          },
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Payment'),
            Tab(text: 'Review'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildProgressStep(0, 'Details', Icons.person),
                _buildProgressLine(),
                _buildProgressStep(1, 'Payment', Icons.payment),
                _buildProgressLine(),
                _buildProgressStep(2, 'Review', Icons.check_circle),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(),
                _buildPaymentTab(),
                _buildReviewTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String title, IconData icon) {
    final isActive = _currentStep >= step;
    final isCompleted = _currentStep > step;
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive ? const Color(0xFFE60012) : Colors.white.withValues(alpha: 0.7),
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.7),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: _currentStep > 0 ? Colors.white : Colors.white.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Delivery Information
          _buildSectionHeader('Delivery Information', Icons.local_shipping),
          const SizedBox(height: 16),
          
          // Delivery Type Selection
          Row(
            children: [
              Expanded(
                child: _buildDeliveryOption(
                  'Home Delivery',
                  'Deliver to your address',
                  Icons.home,
                  'home',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDeliveryOption(
                  'Station Pickup',
                  'Pick up at nearest station',
                  Icons.location_on,
                  'station',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Contact Information
          _buildSectionHeader('Contact Information', Icons.contact_phone),
          const SizedBox(height: 16),
          
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: const Icon(Icons.person),
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
              hintText: 'Enter your phone number',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          
          const SizedBox(height: 16),
          
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: 24),
          
          // Delivery Address
          _buildSectionHeader('Delivery Address', Icons.location_on),
          const SizedBox(height: 16),
          
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Street Address',
              hintText: 'Enter your street address',
              prefixIcon: const Icon(Icons.home),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLines: 2,
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'Enter city',
                    prefixIcon: const Icon(Icons.location_city),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _postalCodeController,
                  decoration: InputDecoration(
                    labelText: 'Postal Code',
                    hintText: 'Enter postal code',
                    prefixIcon: const Icon(Icons.markunread_mailbox),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Delivery Time
          _buildSectionHeader('Delivery Time', Icons.access_time),
          const SizedBox(height: 16),
          
          _buildDeliveryTimeOption('ASAP', 'Deliver as soon as possible', 'asap'),
          _buildDeliveryTimeOption('Today Evening', 'Deliver today between 6-8 PM', 'today_evening'),
          _buildDeliveryTimeOption('Tomorrow Morning', 'Deliver tomorrow between 8-12 PM', 'tomorrow_morning'),
          _buildDeliveryTimeOption('Tomorrow Afternoon', 'Deliver tomorrow between 12-6 PM', 'tomorrow_afternoon'),
          
          const SizedBox(height: 32),
          
          // Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateDetailsAndContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Continue to Payment',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Payment Methods
          _buildSectionHeader('Payment Methods', Icons.payment),
          const SizedBox(height: 16),
          
          _buildPaymentMethodOption(
            'M-Pesa',
            'Pay with M-Pesa mobile money',
            Icons.phone_android,
            'mpesa',
          ),
          _buildPaymentMethodOption(
            'Airtel Money',
            'Pay with Airtel Money',
            Icons.phone_android,
            'airtel',
          ),
          _buildPaymentMethodOption(
            'Card Payment',
            'Pay with debit/credit card',
            Icons.credit_card,
            'card',
          ),
          _buildPaymentMethodOption(
            'Cash on Delivery',
            'Pay when your order arrives',
            Icons.money,
            'cod',
          ),
          
          const SizedBox(height: 24),
          
          // Order Summary
          _buildSectionHeader('Order Summary', Icons.receipt),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
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
              children: [
                _buildOrderSummaryRow('Subtotal', 'KES ${widget.totalAmount.toStringAsFixed(2)}'),
                _buildOrderSummaryRow('Delivery Fee', 'KES ${_deliveryFee.toStringAsFixed(2)}'),
                _buildOrderSummaryRow('Service Fee', 'KES ${_serviceFee.toStringAsFixed(2)}'),
                _buildOrderSummaryRow('VAT (16%)', 'KES ${_tax.toStringAsFixed(2)}'),
                const Divider(),
                _buildOrderSummaryRow(
                  'Total',
                  'KES ${_grandTotal.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validatePaymentAndContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Review Order',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Items
          _buildSectionHeader('Order Items', Icons.shopping_cart),
          const SizedBox(height: 16),
          
          Container(
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
              children: widget.cartItems.map((item) => _buildOrderItem(item)).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Delivery Information
          _buildSectionHeader('Delivery Information', Icons.local_shipping),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
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
                _buildInfoRow('Name', _nameController.text),
                _buildInfoRow('Phone', _phoneController.text),
                _buildInfoRow('Email', _emailController.text),
                _buildInfoRow('Address', _addressController.text),
                _buildInfoRow('City', _cityController.text),
                _buildInfoRow('Delivery Time', _getDeliveryTimeText()),
                _buildInfoRow('Payment Method', _getPaymentMethodText()),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Final Order Summary
          _buildSectionHeader('Final Total', Icons.receipt_long),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE60012).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE60012).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                _buildOrderSummaryRow('Subtotal', 'KES ${widget.totalAmount.toStringAsFixed(2)}'),
                _buildOrderSummaryRow('Delivery Fee', 'KES ${_deliveryFee.toStringAsFixed(2)}'),
                _buildOrderSummaryRow('Service Fee', 'KES ${_serviceFee.toStringAsFixed(2)}'),
                _buildOrderSummaryRow('VAT (16%)', 'KES ${_tax.toStringAsFixed(2)}'),
                const Divider(),
                _buildOrderSummaryRow(
                  'Total Amount',
                  'KES ${_grandTotal.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Place Order Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Place Order - KES ${_grandTotal.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE60012), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOption(String title, String subtitle, IconData icon, String value) {
    final isSelected = _selectedDeliveryType == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDeliveryType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE60012).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE60012) : Colors.grey[300]!,
            width: 2,
          ),
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFFE60012) : Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTimeOption(String title, String subtitle, String value) {
    final isSelected = _selectedDeliveryTime == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDeliveryTime = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE60012).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFE60012) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFE60012) : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFFE60012) : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
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
      ),
    );
  }

  Widget _buildPaymentMethodOption(String title, String subtitle, IconData icon, String value) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE60012).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFE60012) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFE60012) : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFFE60012) : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFE60012) : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFFE60012) : Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFFE60012) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item['type'] != null ? Icons.local_gas_station : Icons.category,
              color: Colors.grey[400],
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'KES ${item['price'].toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE60012),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Qty: 1',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not provided' : value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDeliveryTimeText() {
    switch (_selectedDeliveryTime) {
      case 'asap':
        return 'ASAP - Deliver as soon as possible';
      case 'today_evening':
        return 'Today Evening - 6-8 PM';
      case 'tomorrow_morning':
        return 'Tomorrow Morning - 8-12 PM';
      case 'tomorrow_afternoon':
        return 'Tomorrow Afternoon - 12-6 PM';
      default:
        return 'Not selected';
    }
  }

  String _getPaymentMethodText() {
    switch (_selectedPaymentMethod) {
      case 'mpesa':
        return 'M-Pesa Mobile Money';
      case 'airtel':
        return 'Airtel Money';
      case 'card':
        return 'Debit/Credit Card';
      case 'cod':
        return 'Cash on Delivery';
      default:
        return 'Not selected';
    }
  }

  void _validateDetailsAndContinue() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    _tabController.animateTo(1);
    setState(() {
      _currentStep = 1;
    });
  }

  void _validatePaymentAndContinue() {
    _tabController.animateTo(2);
    setState(() {
      _currentStep = 2;
    });
  }

  void _placeOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE60012)),
            ),
            const SizedBox(height: 16),
            Text(
              'Processing your order...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

    // Simulate order processing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              Text(
                'Order Placed!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your order has been successfully placed.',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'Order ID: #TE${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE60012),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total: KES ${_grandTotal.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You will receive a confirmation SMS shortly.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                if (mounted) {
                  Navigator.pop(context); // Go back to home
                }
              },
              child: Text(
                'Continue Shopping',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFE60012),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
      }
    });
  }
}