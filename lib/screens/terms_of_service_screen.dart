import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE60012), Color(0xFFFF6B35)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.description, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Terms of Service',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Content
            _buildSection(
              '1. Acceptance of Terms',
              'By downloading, installing, or using the TotalEnergies mobile application ("App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, please do not use the App.',
            ),

            _buildSection(
              '2. Description of Service',
              'The TotalEnergies App provides access to fuel station locator, card management, payment services, gas cylinder ordering, and other energy-related services. We reserve the right to modify, suspend, or discontinue any aspect of the service at any time.',
            ),

            _buildSection(
              '3. User Accounts',
              'To access certain features, you must create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to provide accurate and complete information during registration.',
            ),

            _buildSection(
              '4. Payment Terms',
              'Payment for services through the App may be processed via mobile money (M-Pesa), credit/debit cards, or bank transfers. All transactions are processed securely. Prices are subject to change without notice.',
            ),

            _buildSection(
              '5. User Conduct',
              'You agree not to:\n• Use the App for any unlawful purpose\n• Interfere with or disrupt the service\n• Attempt to gain unauthorized access to any part of the App\n• Use automated systems to access the App\n• Share your account credentials with others',
            ),

            _buildSection(
              '6. Privacy and Data Protection',
              'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information. By using the App, you consent to our data practices as described in the Privacy Policy.',
            ),

            _buildSection(
              '7. Intellectual Property',
              'The App and its content, including but not limited to text, graphics, logos, and software, are the property of TotalEnergies and are protected by copyright and other intellectual property laws.',
            ),

            _buildSection(
              '8. Disclaimers',
              'The App is provided "as is" without warranties of any kind. We do not guarantee that the App will be uninterrupted, secure, or error-free. We are not liable for any damages arising from your use of the App.',
            ),

            _buildSection(
              '9. Limitation of Liability',
              'To the maximum extent permitted by law, TotalEnergies shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, or use.',
            ),

            _buildSection(
              '10. Termination',
              'We may terminate or suspend your account and access to the App at any time, with or without cause or notice. Upon termination, your right to use the App will cease immediately.',
            ),

            _buildSection(
              '11. Changes to Terms',
              'We reserve the right to modify these Terms at any time. We will notify users of any material changes through the App or by email. Your continued use of the App after changes constitutes acceptance of the new Terms.',
            ),

            _buildSection(
              '12. Governing Law',
              'These Terms shall be governed by and construed in accordance with the laws of Kenya. Any disputes arising from these Terms or your use of the App shall be subject to the exclusive jurisdiction of the courts of Kenya.',
            ),

            _buildSection(
              '13. Contact Information',
              'If you have any questions about these Terms, please contact us at:\n\nTotalEnergies Kenya\nEmail: support@totalenergies.co.ke\nPhone: +254 700 000 000\nAddress: TotalEnergies Kenya Limited, Nairobi, Kenya',
            ),

            const SizedBox(height: 32),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey[600], size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'Important Notice',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please read these Terms carefully. By using the TotalEnergies App, you acknowledge that you have read, understood, and agree to be bound by these Terms.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE60012),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
