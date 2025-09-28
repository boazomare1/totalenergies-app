import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/otp_service.dart';
import '../services/auth_service.dart';
import '../widgets/otp_verification_dialog.dart';

class MpesaPaymentScreen extends StatefulWidget {
  final double amount;
  final Function(String phoneNumber) onPaymentSuccess;

  const MpesaPaymentScreen({
    Key? key,
    required this.amount,
    required this.onPaymentSuccess,
  }) : super(key: key);

  @override
  State<MpesaPaymentScreen> createState() => _MpesaPaymentScreenState();
}

class _MpesaPaymentScreenState extends State<MpesaPaymentScreen> {
  final _mpesaPaymentFormKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      _phoneNumberController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'M-Pesa Payment',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _mpesaPaymentFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Summary
              Container(
                width: double.infinity,
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
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount to Pay:',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'KSh ${widget.amount.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE60012),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Method:',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_android,
                              color: const Color(0xFFE60012),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'M-Pesa',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFE60012),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // M-Pesa Information
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'M-Pesa Information',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Phone Number Input
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'M-Pesa Phone Number',
                        hintText: '07XX XXX XXX',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: Colors.grey[600],
                        ),
                        prefixText: '+254 ',
                        prefixStyle: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        if (value.length < 9) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Format phone number
                        String formatted = value.replaceAll(' ', '');
                        if (formatted.length > 9) {
                          formatted = formatted.substring(0, 9);
                        }
                        if (formatted.length >= 3) {
                          formatted =
                              formatted.substring(0, 3) +
                              ' ' +
                              formatted.substring(3);
                        }
                        if (formatted.length >= 7) {
                          formatted =
                              formatted.substring(0, 7) +
                              ' ' +
                              formatted.substring(7);
                        }
                        if (formatted != value) {
                          _phoneNumberController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // M-Pesa Instructions
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.green[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Payment Instructions',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '1. Enter your M-Pesa registered phone number\n'
                            '2. Tap "Pay with M-Pesa" to initiate payment\n'
                            '3. Enter your M-Pesa PIN when prompted\n'
                            '4. Wait for confirmation SMS',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Security Notice
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your payment is processed securely by Safaricom',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Payment Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60012),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            'Pay KSh ${widget.amount.toStringAsFixed(2)} with M-Pesa',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 16),

              // M-Pesa Logo
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: Colors.green[600],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Powered by M-Pesa',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    if (_mpesaPaymentFormKey.currentState!.validate()) {
      final phoneNumber = _phoneNumberController.text.replaceAll(' ', '');

      setState(() {
        _isProcessing = true;
      });

      try {
        // Send OTP for payment verification
        await OTPService.sendOTP(phoneNumber, 'M-Pesa Payment');

        setState(() {
          _isProcessing = false;
        });

        // Show OTP verification dialog
        final otpVerified = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => OTPVerificationDialog(
                phoneNumber: phoneNumber,
                purpose: 'M-Pesa Payment',
                onSuccess: () {
                  // Process payment after OTP verification
                  _completePayment(phoneNumber);
                },
              ),
        );

        if (otpVerified == true) {
          // Payment completed successfully
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send OTP. Please try again.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _completePayment(String phoneNumber) async {
    // Simulate M-Pesa payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Call success callback
    widget.onPaymentSuccess(phoneNumber);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'M-Pesa payment successful! Card topped up with KSh ${widget.amount.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
