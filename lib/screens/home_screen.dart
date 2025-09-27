import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'station_finder_screen.dart';
import 'card_screen.dart';
import 'offers_screen.dart';
import 'gas_products_screen.dart';
import 'pay_at_station_screen.dart';
import 'quartz_oil_finder_screen.dart';
import 'beyond_fuel_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  late PageController _bannerController;
  bool _hasShownNewsletterPopup = false;
  String _newsletterPreference = 'show'; // 'show', 'later', 'never'

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startBannerAutoScroll();
    _showNewsletterOptIn();

    // Reset preference after 5 minutes for "Show Later" users (for testing)
    if (_newsletterPreference == 'later') {
      Future.delayed(const Duration(minutes: 5), () {
        if (mounted) {
          setState(() {
            _newsletterPreference = 'show';
            _hasShownNewsletterPopup = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_bannerController.hasClients) {
        _currentBannerIndex = (_currentBannerIndex + 1) % 5;
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startBannerAutoScroll();
      }
    });
  }

  String _getTimeBasedGreeting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return l10n.goodMorning;
    } else if (hour >= 12 && hour < 16) {
      return l10n.goodAfternoon;
    } else if (hour >= 16 && hour < 20) {
      return l10n.goodEvening;
    } else {
      return l10n.goodNight;
    }
  }

  IconData _getTimeBasedIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return Icons.wb_sunny; // Sun icon for morning
    } else if (hour >= 12 && hour < 16) {
      return Icons.wb_sunny_outlined; // Sun outline for afternoon
    } else if (hour >= 16 && hour < 20) {
      return Icons.wb_twilight; // Twilight icon for evening
    } else {
      return Icons.nightlight_round; // Crescent moon for night
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: const Color(0xFFE60012),
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE60012), Color(0xFFFF6B35)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/totalenergies_logo_white.png',
                          height: 32,
                          width: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                _getTimeBasedGreeting(context),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _getTimeBasedIcon(),
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Promotional Banner Carousel
                _buildBannerCarousel(),

                const SizedBox(height: 24),

                // Quick Actions Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.quickActions,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToScreen(const OffersScreen()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.card_giftcard,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '5 ${AppLocalizations.of(context)!.offers.toLowerCase()}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Service Cards
                _buildServiceCards(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildBannerCard(index);
            },
          ),
          // Navigation arrows
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _currentBannerIndex = (_currentBannerIndex - 1 + 5) % 5;
                  _bannerController.animateToPage(
                    _currentBannerIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _currentBannerIndex = (_currentBannerIndex + 1) % 5;
                  _bannerController.animateToPage(
                    _currentBannerIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          // Pagination dots
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentBannerIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        _currentBannerIndex == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard(int index) {
    final banners = [
      {
        'title': 'Quartz',
        'subtitle': 'Choose the right oil',
        'button': 'Find product',
        'image': 'assets/images/banner_quartz_oil_bg.png',
      },
      {
        'title': 'Enjoy',
        'subtitle': 'Convenience meets quality!',
        'button': 'Find a store',
        'image': 'assets/images/banner_enjoy_bg.png',
      },
      {
        'title': 'KFC',
        'subtitle': 'Famous fried chicken',
        'button': 'Drive-thru',
        'image': 'assets/images/banner_kfc_bg.png',
      },
      {
        'title': 'TotalEnergies Card',
        'subtitle': 'Enjoy a discount every time',
        'button': 'Explore',
        'image': 'assets/images/banner_card_bg.png',
      },
      {
        'title': 'TotalEnergies Gas',
        'subtitle': 'Need your gas home',
        'button': 'Order Now',
        'image': 'assets/images/banner_gas_delivery_bg.png',
      },
    ];

    final banner = banners[index];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                banner['image'] as String,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
            // Dark overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          banner['title'] as String,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          banner['subtitle'] as String,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () => _handleBannerTap(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFE60012),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          banner['button'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Station Finder Card
          _buildServiceCard(
            AppLocalizations.of(context)!.stationFinder,
            'Find nearby TotalEnergies stations',
            Icons.location_on,
            Colors.amber,
            () => _navigateToScreen(const StationFinderScreen()),
          ),
          const SizedBox(height: 12),

          // TotalEnergies Gas Card
          _buildServiceCard(
            AppLocalizations.of(context)!.totalGas,
            'Order gas cylinders for home delivery',
            Icons.local_gas_station,
            Colors.green,
            () => _navigateToScreen(const GasProductsScreen()),
          ),
          const SizedBox(height: 12),

          // Quartz Card
          _buildServiceCard(
            AppLocalizations.of(context)!.quartzOil,
            'Choose the right oil',
            Icons.oil_barrel,
            Colors.orange,
            () => _navigateToScreen(const QuartzOilFinderScreen()),
          ),
          const SizedBox(height: 12),

          // Pay at Station Card
          _buildServiceCard(
            AppLocalizations.of(context)!.payAtStation,
            'Pay for Fuel, Gas & Lub...',
            Icons.payment,
            Colors.blue,
            () => _showPayAtStationModal(),
          ),
          const SizedBox(height: 12),

          // Beyond Fuel Card
          _buildServiceCard(
            AppLocalizations.of(context)!.beyondFuel,
            AppLocalizations.of(context)!.beyondFuelSubtitle,
            Icons.restaurant,
            Colors.purple,
            () => _navigateToScreen(const BeyondFuelScreen()),
          ),
          const SizedBox(height: 12),

          // TotalEnergies Card
          _buildServiceCard(
            AppLocalizations.of(context)!.myCard,
            'Apply | Top Up | Manage...',
            Icons.credit_card,
            const Color(0xFFE60012),
            () => _navigateToScreen(const CardScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _handleBannerTap(int index) {
    switch (index) {
      case 0: // Quartz Oil
        _navigateToScreen(const QuartzOilFinderScreen());
        break;
      case 1: // Enjoy Store
        _navigateToScreen(const BeyondFuelScreen());
        break;
      case 2: // KFC
        _navigateToScreen(const BeyondFuelScreen());
        break;
      case 3: // TotalEnergies Card
        _navigateToScreen(const CardScreen());
        break;
      case 4: // TotalEnergies Gas
        _navigateToScreen(const GasProductsScreen());
        break;
      default:
        break;
    }
  }

  void _showPayAtStationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const PayAtStationScreen(),
          ),
    );
  }

  void _showNewsletterOptIn() {
    if (!_hasShownNewsletterPopup && _newsletterPreference == 'show') {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => _NewsletterOptInDialog(
                  onOptIn: () {
                    setState(() {
                      _hasShownNewsletterPopup = true;
                      _newsletterPreference = 'never';
                    });
                    Navigator.pop(context);
                    _showOptInSuccess();
                  },
                  onSkip: () {
                    setState(() {
                      _hasShownNewsletterPopup = true;
                      _newsletterPreference = 'never';
                    });
                    Navigator.pop(context);
                  },
                  onLater: () {
                    setState(() {
                      _hasShownNewsletterPopup = true;
                      _newsletterPreference = 'later';
                    });
                    Navigator.pop(context);
                    _showLaterMessage();
                  },
                  onNever: () {
                    setState(() {
                      _hasShownNewsletterPopup = true;
                      _newsletterPreference = 'never';
                    });
                    Navigator.pop(context);
                  },
                ),
          );
        }
      });
    }
  }

  void _showOptInSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.thankYouOptIn,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showLaterMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.noProblemLater,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _NewsletterOptInDialog extends StatefulWidget {
  final VoidCallback onOptIn;
  final VoidCallback onSkip;
  final VoidCallback onLater;
  final VoidCallback onNever;

  const _NewsletterOptInDialog({
    required this.onOptIn,
    required this.onSkip,
    required this.onLater,
    required this.onNever,
  });

  @override
  State<_NewsletterOptInDialog> createState() => _NewsletterOptInDialogState();
}

class _NewsletterOptInDialogState extends State<_NewsletterOptInDialog> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isOptingIn = false;
  bool _showBenefits = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE60012).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.campaign,
                  size: 48,
                  color: const Color(0xFFE60012),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                AppLocalizations.of(context)!.newsletterOptIn,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFE60012),
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                AppLocalizations.of(context)!.newsletterDescription,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Phone Number Input
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+254 7XX XXX XXX',
                  prefixIcon: Icon(Icons.phone, color: const Color(0xFFE60012)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE60012),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Benefits Toggle
              GestureDetector(
                onTap: _toggleBenefits,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _showBenefits
                            ? Icons.keyboard_arrow_up
                            : Icons.info_outline,
                        color: const Color(0xFFE60012),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _showBenefits
                            ? AppLocalizations.of(context)!.hideBenefits
                            : AppLocalizations.of(context)!.whatYoullReceive,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFFE60012),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Benefits List (Expandable)
              if (_showBenefits) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildBenefitItem(
                        AppLocalizations.of(
                          context,
                        )!.exclusiveOffersAndDiscounts,
                      ),
                      _buildBenefitItem(
                        AppLocalizations.of(context)!.latestFuelPriceUpdates,
                      ),
                      _buildBenefitItem(
                        AppLocalizations.of(context)!.newStationOpenings,
                      ),
                      _buildBenefitItem(
                        AppLocalizations.of(context)!.serviceReminders,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Action Buttons
              Column(
                children: [
                  // Primary Action Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isOptingIn ? null : _optIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE60012),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              _isOptingIn
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    AppLocalizations.of(context)!.optIn,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onSkip,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFFE60012)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.skip,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFFE60012),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Preference Selection
                  Text(
                    'Or choose your preference:',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Radio Button Style Options
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Show Later Option
                        InkWell(
                          onTap: widget.onLater,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: Colors.orange[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.showLater,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        'Ask me again in a few minutes',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Divider
                        Container(
                          height: 1,
                          color: Colors.grey[200],
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        // Never Show Again Option
                        InkWell(
                          onTap: widget.onNever,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.block,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.neverShowAgain,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        'Don\'t show this popup anymore',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleBenefits() {
    setState(() {
      _showBenefits = !_showBenefits;
    });
  }

  void _optIn() {
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your phone number',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isOptingIn = true;
    });

    // Simulate opt-in process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isOptingIn = false;
        });
        widget.onOptIn();
      }
    });
  }
}
