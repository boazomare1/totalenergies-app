import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'analytics_screen.dart';
import 'language_selection_screen.dart';
import '../services/language_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _offlineMode = false;
  bool _locationServices = true;
  bool _biometricAuth = false;
  bool _darkMode = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'KSh';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final languageCode = await LanguageService.getCurrentLanguage();
    setState(() {
      _selectedLanguage = LanguageService.getLanguageName(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          // Profile Section
          _buildSectionHeader('Profile'),
          _buildProfileCard(),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            'Push Notifications',
            'Receive push notifications for updates and offers',
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
            Icons.notifications,
          ),
          _buildSwitchTile(
            'Email Notifications',
            'Get updates via email',
            _emailNotifications,
            (value) => setState(() => _emailNotifications = value),
            Icons.email,
          ),
          _buildSwitchTile(
            'SMS Notifications',
            'Receive important updates via SMS',
            _smsNotifications,
            (value) => setState(() => _smsNotifications = value),
            Icons.sms,
          ),

          // App Settings Section
          _buildSectionHeader('App Settings'),
          _buildSwitchTile(
            'Offline Mode',
            'Enable offline functionality for basic features',
            _offlineMode,
            (value) => setState(() => _offlineMode = value),
            Icons.offline_bolt,
          ),
          _buildSwitchTile(
            'Dark Mode',
            'Switch to dark theme',
            _darkMode,
            (value) => setState(() => _darkMode = value),
            Icons.dark_mode,
          ),
          _buildListTile(
            AppLocalizations.of(context)!.language,
            _selectedLanguage,
            Icons.language,
            () => _navigateToLanguageSelection(),
          ),
          _buildListTile(
            'Currency',
            _selectedCurrency,
            Icons.attach_money,
            () => _showCurrencyDialog(),
          ),

          // Privacy & Security Section
          _buildSectionHeader('Privacy & Security'),
          _buildListTile(
            'Analytics & Insights',
            'View your usage statistics and insights',
            Icons.analytics,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            ),
          ),
          _buildSwitchTile(
            'Location Services',
            'Allow app to access your location for station finder',
            _locationServices,
            (value) => setState(() => _locationServices = value),
            Icons.location_on,
          ),
          _buildSwitchTile(
            'Biometric Authentication',
            'Use fingerprint or face ID for secure access',
            _biometricAuth,
            (value) => setState(() => _biometricAuth = value),
            Icons.fingerprint,
          ),
          _buildListTile(
            'Privacy Policy',
            'View our privacy policy',
            Icons.privacy_tip,
            () => _showPrivacyPolicy(),
          ),
          _buildListTile(
            'Terms of Service',
            'View terms and conditions',
            Icons.description,
            () => _showTermsOfService(),
          ),

          // Support Section
          _buildSectionHeader('Support'),
          _buildListTile(
            'Help Center',
            'Get help and support',
            Icons.help_center,
            () => _showHelpCenter(),
          ),
          _buildListTile(
            'Contact Us',
            'Get in touch with our team',
            Icons.contact_support,
            () => _showContactUs(),
          ),
          _buildListTile(
            'Rate App',
            'Rate us on the app store',
            Icons.star,
            () => _rateApp(),
          ),
          _buildListTile(
            'Share App',
            'Share with friends and family',
            Icons.share,
            () => _shareApp(),
          ),

          // About Section
          _buildSectionHeader('About'),
          _buildListTile('App Version', '1.0.0', Icons.info, null),
          _buildListTile('Build Number', '100', Icons.build, null),
          _buildListTile(
            'Open Source Licenses',
            'View third-party licenses',
            Icons.code,
            () => _showLicenses(),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE60012),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFFE60012).withValues(alpha: 0.1),
            child: Icon(Icons.person, size: 30, color: const Color(0xFFE60012)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+254 712 345 678',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _editProfile(),
            icon: Icon(Icons.edit, color: const Color(0xFFE60012)),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFE60012),
        secondary: Icon(icon, color: const Color(0xFFE60012)),
      ),
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback? onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
        leading: Icon(icon, color: const Color(0xFFE60012)),
        trailing:
            onTap != null
                ? Icon(Icons.chevron_right, color: Colors.grey[400])
                : null,
        onTap: onTap,
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Edit Profile',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Profile editing feature will be available in the next update.',
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

  void _navigateToLanguageSelection() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
    );

    // Refresh language after returning from language selection
    if (result == true || result == null) {
      await _loadCurrentLanguage();
    }
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Select Currency',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCurrencyOption('KSh', 'Kenyan Shilling'),
                _buildCurrencyOption('USD', 'US Dollar'),
                _buildCurrencyOption('EUR', 'Euro'),
              ],
            ),
          ),
    );
  }

  Widget _buildCurrencyOption(String code, String name) {
    return ListTile(
      title: Text('$code - $name', style: GoogleFonts.poppins()),
      trailing:
          _selectedCurrency == code
              ? Icon(Icons.check, color: const Color(0xFFE60012))
              : null,
      onTap: () {
        setState(() => _selectedCurrency = code);
        Navigator.pop(context);
      },
    );
  }

  void _showPrivacyPolicy() {
    _showInfoDialog(
      'Privacy Policy',
      'Our privacy policy outlines how we collect, use, and protect your personal information.',
    );
  }

  void _showTermsOfService() {
    _showInfoDialog(
      'Terms of Service',
      'These terms govern your use of the TotalEnergies mobile application.',
    );
  }

  void _showHelpCenter() {
    _showInfoDialog(
      'Help Center',
      'Visit our help center for frequently asked questions and support resources.',
    );
  }

  void _showContactUs() {
    _showInfoDialog(
      'Contact Us',
      'Email: support@totalenergies.com\nPhone: +254 700 000 000\nHours: 8 AM - 6 PM (EAT)',
    );
  }

  void _rateApp() {
    _showInfoDialog(
      'Rate App',
      'Thank you for using TotalEnergies! Please rate us on the app store.',
    );
  }

  void _shareApp() {
    _showInfoDialog(
      'Share App',
      'Share TotalEnergies app with your friends and family.',
    );
  }

  void _showLicenses() {
    _showInfoDialog(
      'Open Source Licenses',
      'This app uses various open source libraries. View licenses for more details.',
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(content, style: GoogleFonts.poppins()),
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
}
