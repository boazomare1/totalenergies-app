import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
                  Icon(Icons.privacy_tip, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Privacy Policy',
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
              '1. Introduction',
              'TotalEnergies Kenya Limited ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the TotalEnergies mobile application.',
            ),

            _buildSection(
              '2. Information We Collect',
              'We collect information you provide directly to us, such as:\n\n• Personal Information: Name, email address, phone number, date of birth\n• Account Information: Username, password, account preferences\n• Payment Information: Credit card details, mobile money information\n• Location Information: GPS coordinates, address information\n• Device Information: Device type, operating system, unique device identifiers\n• Usage Information: App usage patterns, feature interactions, transaction history',
            ),

            _buildSection(
              '3. How We Use Your Information',
              'We use the information we collect to:\n\n• Provide and maintain the App services\n• Process transactions and payments\n• Send you important updates and notifications\n• Improve our services and develop new features\n• Provide customer support\n• Comply with legal obligations\n• Protect against fraud and unauthorized transactions\n• Analyze usage patterns to enhance user experience',
            ),

            _buildSection(
              '4. Information Sharing and Disclosure',
              'We may share your information in the following circumstances:\n\n• With service providers who assist us in operating the App\n• With payment processors for transaction processing\n• With law enforcement when required by law\n• In connection with a business transfer or acquisition\n• With your consent for other purposes\n\nWe do not sell your personal information to third parties.',
            ),

            _buildSection(
              '5. Data Security',
              'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure.',
            ),

            _buildSection(
              '6. Location Services',
              'The App may request access to your location to:\n• Help you find nearby TotalEnergies stations\n• Provide location-based services and offers\n• Improve service delivery\n\nYou can control location permissions through your device settings.',
            ),

            _buildSection(
              '7. Biometric Authentication',
              'The App may use biometric authentication (fingerprint, face ID) for secure access. Biometric data is stored locally on your device and is not transmitted to our servers.',
            ),

            _buildSection(
              '8. Cookies and Tracking',
              'We use cookies and similar tracking technologies to:\n• Remember your preferences\n• Analyze app usage\n• Provide personalized content\n• Improve performance\n\nYou can control cookie settings through your device or browser preferences.',
            ),

            _buildSection(
              '9. Data Retention',
              'We retain your personal information for as long as necessary to provide our services and fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.',
            ),

            _buildSection(
              '10. Your Rights and Choices',
              'You have the right to:\n\n• Access your personal information\n• Correct inaccurate information\n• Delete your account and data\n• Opt out of marketing communications\n• Restrict certain data processing\n• Data portability\n• Withdraw consent\n\nTo exercise these rights, contact us using the information provided below.',
            ),

            _buildSection(
              '11. Children\'s Privacy',
              'The App is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information.',
            ),

            _buildSection(
              '12. International Data Transfers',
              'Your information may be transferred to and processed in countries other than Kenya. We ensure that such transfers comply with applicable data protection laws and implement appropriate safeguards.',
            ),

            _buildSection(
              '13. Changes to This Privacy Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the App and updating the "Last updated" date. Your continued use of the App after changes constitutes acceptance of the updated policy.',
            ),

            _buildSection(
              '14. Third-Party Services',
              'The App may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to read their privacy policies.',
            ),

            _buildSection(
              '15. Contact Us',
              'If you have any questions about this Privacy Policy or our data practices, please contact us at:\n\nTotalEnergies Kenya Limited\nData Protection Officer\nEmail: privacy@totalenergies.co.ke\nPhone: +254 700 000 000\nAddress: TotalEnergies Kenya Limited, Nairobi, Kenya\n\nYou also have the right to lodge a complaint with the Data Protection Commissioner of Kenya.',
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
                  Icon(Icons.security, color: Colors.grey[600], size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'Your Privacy Matters',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We are committed to protecting your privacy and ensuring the security of your personal information. If you have any concerns or questions, please don\'t hesitate to contact us.',
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
