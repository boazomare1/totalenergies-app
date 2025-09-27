import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/dashboard_service.dart';

class BankTransferScreen extends StatefulWidget {
  final double amount;

  const BankTransferScreen({super.key, required this.amount});

  @override
  State<BankTransferScreen> createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _bankController = TextEditingController();
  final _referenceController = TextEditingController();
  
  String _selectedBank = '';
  bool _isProcessing = false;
  bool _isOTPVerified = false;
  final _otpController = TextEditingController();

  final List<Map<String, String>> _banks = [
    {'code': 'KCB', 'name': 'Kenya Commercial Bank (KCB)'},
    {'code': 'EQUITY', 'name': 'Equity Bank'},
    {'code': 'COOP', 'name': 'Co-operative Bank'},
    {'code': 'ABSA', 'name': 'Absa Bank Kenya'},
    {'code': 'NCBA', 'name': 'NCBA Bank'},
    {'code': 'STANBIC', 'name': 'Stanbic Bank Kenya'},
    {'code': 'DTB', 'name': 'Diamond Trust Bank'},
    {'code': 'I&M', 'name': 'I&M Bank'},
    {'code': 'HF', 'name': 'HF Group'},
    {'code': 'CITI', 'name': 'Citi Bank Kenya'},
  ];

  @override
  void dispose() {
    _accountNumberController.dispose();
    _bankController.dispose();
    _referenceController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bank Transfer',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE60012), Color(0xFFFF6B35)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Top-up Amount',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'KSh ${widget.amount.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Bank Selection
              Text(
                'Select Bank',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedBank.isEmpty ? null : _selectedBank,
                decoration: InputDecoration(
                  hintText: 'Choose your bank',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.account_balance, color: Color(0xFFE60012)),
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
                    borderSide: const BorderSide(color: Color(0xFFE60012), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _banks.map((bank) {
                  return DropdownMenuItem<String>(
                    value: bank['code'],
                    child: Text(
                      bank['name']!,
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBank = value ?? '';
                    _bankController.text = _banks.firstWhere((bank) => bank['code'] == value)['name'] ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a bank';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Account Number
              _buildInputField(
                controller: _accountNumberController,
                label: 'Account Number',
                hint: 'Enter your account number',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your account number';
                  }
                  if (value.length < 8) {
                    return 'Account number must be at least 8 digits';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Reference Number
              _buildInputField(
                controller: _referenceController,
                label: 'Reference Number (Optional)',
                hint: 'Enter reference number',
                icon: Icons.receipt_long,
                validator: (value) {
                  return null; // Optional field
                },
              ),

              const SizedBox(height: 30),

              // Bank Transfer Instructions
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
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Transfer Instructions',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Use your mobile banking app or visit your bank branch\n'
                      '2. Transfer exactly KSh ${widget.amount.toStringAsFixed(2)} to:\n'
                      '   Account: 1234567890\n'
                      '   Bank: TotalEnergies Kenya Ltd\n'
                      '   Reference: ${_referenceController.text.isNotEmpty ? _referenceController.text : 'FUEL-${DateTime.now().millisecondsSinceEpoch}'}\n'
                      '3. Complete the transfer and return to this screen\n'
                      '4. Click "I have transferred" to verify your payment',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.blue[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // OTP Verification (shown after transfer confirmation)
              if (_isOTPVerified) ...[
                _buildInputField(
                  controller: _otpController,
                  label: 'Enter OTP',
                  hint: 'Enter 6-digit OTP sent to your phone',
                  icon: Icons.security,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP';
                    }
                    if (value.length != 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isProcessing ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE60012)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFE60012),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _handleTransfer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60012),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isOTPVerified ? 'Verify & Complete' : 'I have transferred',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: const Color(0xFFE60012)),
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
              borderSide: const BorderSide(color: Color(0xFFE60012), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Future<void> _handleTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isOTPVerified) {
      // First step: Confirm transfer
      setState(() {
        _isProcessing = true;
      });

      // Simulate processing
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isProcessing = false;
        _isOTPVerified = true;
      });

      // Show OTP dialog
      _showOTPDialog();
    } else {
      // Second step: Verify OTP and complete
      await _verifyOTPAndComplete();
    }
  }

  void _showOTPDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'OTP Sent',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.message,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'We have sent a 6-digit OTP to your registered phone number. Please check your messages and enter the code below.',
              style: GoogleFonts.poppins(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'OTP: 123456', // Demo OTP
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE60012),
              ),
            ),
          ],
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

  Future<void> _verifyOTPAndComplete() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate OTP verification
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful payment
    await DashboardService.addTransaction(
      type: 'topup',
      amount: widget.amount,
      description: 'Card Top-up via Bank Transfer - ${_bankController.text}',
    );

    // Update balance
    final currentBalance = await DashboardService.getFuelCardBalance();
    await DashboardService.updateFuelCardBalance(currentBalance + widget.amount);

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate success
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment successful! Your card has been topped up with KSh ${widget.amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}