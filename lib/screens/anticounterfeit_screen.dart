import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnticounterfeitScreen extends StatefulWidget {
  const AnticounterfeitScreen({super.key});

  @override
  State<AnticounterfeitScreen> createState() => _AnticounterfeitScreenState();
}

class _AnticounterfeitScreenState extends State<AnticounterfeitScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _scannedCode = '';
  List<Map<String, dynamic>> _verificationHistory = [];

  // Scratch code variables
  String _hiddenCode = 'GAS2024TE001';
  String _revealedCode = '';
  bool _isCodeRevealed = false;
  List<Offset> _scratchPoints = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Sample verification history
    _verificationHistory = [
      {
        'id': 'VER-001',
        'product': 'Quartz 9000 5W-30',
        'code': 'QRZ9000-5W30-2024-001',
        'date': '2024-01-15',
        'time': '14:30',
        'status': 'Authentic',
        'station': 'TotalEnergies Westlands',
        'batch': 'B240115001',
        'manufactureDate': '2024-01-10',
        'expiryDate': '2026-01-10',
      },
      {
        'id': 'VER-002',
        'product': 'Quartz 7000 10W-40',
        'code': 'QRZ7000-10W40-2024-002',
        'date': '2024-01-12',
        'time': '09:15',
        'status': 'Counterfeit',
        'station': 'TotalEnergies Karen',
        'batch': 'B240112002',
        'manufactureDate': '2024-01-08',
        'expiryDate': '2026-01-08',
        'warning': 'Product code not found in database',
      },
      {
        'id': 'VER-003',
        'product': 'Quartz 5000 15W-40',
        'code': 'QRZ5000-15W40-2024-003',
        'date': '2024-01-10',
        'time': '16:45',
        'status': 'Authentic',
        'station': 'TotalEnergies Thika Road',
        'batch': 'B240110003',
        'manufactureDate': '2024-01-05',
        'expiryDate': '2026-01-05',
      },
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Anticounterfeit',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Scan'),
            Tab(text: 'History'),
            Tab(text: 'Report'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildScanTab(), _buildHistoryTab(), _buildReportTab()],
      ),
    );
  }

  Widget _buildScanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE60012).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE60012).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFE60012),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'How to Verify Your Cylinder',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE60012),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '1. Locate the scratch code on your gas cylinder\n2. Use your finger to scratch off the silver coating\n3. Enter the revealed code below\n4. Get instant verification results',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Authenticity Banner with Scratch Code
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/banner_authenticity.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Semi-transparent overlay for better visibility
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                
                // Scratch Code Area - Centered
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scratch to Verify',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 250,
                        child: _buildScratchCodeArea(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tap and drag to scratch off the silver coating',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Code Verification
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
                Row(
                  children: [
                    Icon(
                      _isCodeRevealed ? Icons.check_circle : Icons.info_outline,
                      color:
                          _isCodeRevealed
                              ? Colors.green
                              : const Color(0xFFE60012),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCodeRevealed ? 'Code Revealed' : 'Enter Code',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isCodeRevealed ? Colors.green : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Revealed code display
                if (_isCodeRevealed)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Revealed Code:',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _revealedCode,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // Manual entry field
                TextField(
                  controller: TextEditingController(
                    text: _isCodeRevealed ? _revealedCode : _scannedCode,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        _isCodeRevealed
                            ? 'Code automatically filled'
                            : 'Enter product code manually',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    prefixIcon: Icon(
                      _isCodeRevealed ? Icons.verified : Icons.edit,
                      color:
                          _isCodeRevealed
                              ? Colors.green
                              : const Color(0xFFE60012),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color:
                            _isCodeRevealed
                                ? Colors.green
                                : const Color(0xFFE60012),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _scannedCode = value;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Reset button if code is revealed
                if (_isCodeRevealed)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isCodeRevealed = false;
                              _revealedCode = '';
                              _scratchPoints.clear();
                              _scannedCode = '';
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Reset'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _scannedCode.isNotEmpty ? _verifyProduct : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE60012),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Verify Product',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _scannedCode.isNotEmpty ? _verifyProduct : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60012),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Verify Product',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
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

  Widget _buildHistoryTab() {
    if (_verificationHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No verification history',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your verification history will appear here',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _verificationHistory.length,
      itemBuilder: (context, index) {
        final verification = _verificationHistory[index];
        return _buildVerificationCard(verification);
      },
    );
  }

  Widget _buildVerificationCard(Map<String, dynamic> verification) {
    Color statusColor;
    IconData statusIcon;

    switch (verification['status']) {
      case 'Authentic':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Counterfeit':
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        verification['product'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        verification['code'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ).copyWith(fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${verification['date']} at ${verification['time']}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    verification['status'],
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildDetailRow('Station', verification['station']),
                _buildDetailRow('Batch Number', verification['batch']),
                _buildDetailRow(
                  'Manufacture Date',
                  verification['manufactureDate'],
                ),
                _buildDetailRow('Expiry Date', verification['expiryDate']),
                if (verification['warning'] != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red[700], size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            verification['warning'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewVerificationDetails(verification),
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE60012),
                      side: const BorderSide(color: Color(0xFFE60012)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareVerification(verification),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE60012),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Report Counterfeit Section
          Container(
            padding: const EdgeInsets.all(20),
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
                Row(
                  children: [
                    Icon(
                      Icons.report_problem,
                      color: Colors.red[600],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Report Counterfeit Product',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Help us fight counterfeiting by reporting suspicious products. Your report will be investigated and may help protect other customers.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _reportCounterfeit,
                    icon: const Icon(Icons.report),
                    label: const Text('Report Counterfeit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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

  void _verifyProduct() {
    if (_scannedCode.isEmpty) return;

    // Simulate verification
    _showVerificationResult();
  }

  void _showVerificationResult() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Verification Result',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Product Code: $_scannedCode',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ).copyWith(fontFamily: 'monospace'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: Authentic',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
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

  void _viewVerificationDetails(Map<String, dynamic> verification) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Verification Details',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Product', verification['product']),
                  _buildDetailRow('Code', verification['code']),
                  _buildDetailRow('Status', verification['status']),
                  _buildDetailRow('Station', verification['station']),
                  _buildDetailRow('Batch', verification['batch']),
                  _buildDetailRow(
                    'Manufacture Date',
                    verification['manufactureDate'],
                  ),
                  _buildDetailRow('Expiry Date', verification['expiryDate']),
                ],
              ),
            ),
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

  void _shareVerification(Map<String, dynamic> verification) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sharing verification details...',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFFE60012),
      ),
    );
  }

  void _reportCounterfeit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Report Counterfeit',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Product Name',
                            hintText: 'Enter product name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Product Code',
                            hintText: 'Enter product code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Station Location',
                            hintText: 'Where did you find this product?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText:
                                'Describe why you think this is counterfeit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Report submitted successfully!',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: const Color(0xFFE60012),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Submit Report',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildScratchCodeArea() {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _scratchPoints.add(details.localPosition);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _scratchPoints.add(details.localPosition);
          _checkScratchProgress();
        });
      },
      onPanEnd: (details) {
        _checkScratchProgress();
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[600]!, width: 2),
        ),
        child: Stack(
          children: [
            // Silver coating layer
            Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[400]!,
                    Colors.grey[300]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            // Scratch effect overlay
            if (_scratchPoints.isNotEmpty)
              CustomPaint(
                size: const Size(double.infinity, 60),
                painter: ScratchPainter(_scratchPoints),
              ),

            // Revealed code
            if (_isCodeRevealed)
              Center(
                child: Text(
                  _hiddenCode,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),

            // Scratch instruction
            if (!_isCodeRevealed)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Scratch here to reveal code',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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

  void _checkScratchProgress() {
    // Calculate scratch coverage (simplified)
    double coverage =
        _scratchPoints.length / 50.0; // Adjust threshold as needed

    if (coverage > 0.3 && !_isCodeRevealed) {
      // 30% scratched
      setState(() {
        _isCodeRevealed = true;
        _revealedCode = _hiddenCode;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Code revealed! You can now verify it below.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class ScannerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFE60012)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final frameSize = 120.0;

    // Draw scanning frame
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: frameSize,
        height: frameSize,
      ),
      paint,
    );

    // Draw corner brackets
    final bracketLength = 20.0;

    // Top-left
    canvas.drawLine(
      Offset(centerX - frameSize / 2, centerY - frameSize / 2),
      Offset(centerX - frameSize / 2 + bracketLength, centerY - frameSize / 2),
      paint,
    );
    canvas.drawLine(
      Offset(centerX - frameSize / 2, centerY - frameSize / 2),
      Offset(centerX - frameSize / 2, centerY - frameSize / 2 + bracketLength),
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(centerX + frameSize / 2, centerY - frameSize / 2),
      Offset(centerX + frameSize / 2 - bracketLength, centerY - frameSize / 2),
      paint,
    );
    canvas.drawLine(
      Offset(centerX + frameSize / 2, centerY - frameSize / 2),
      Offset(centerX + frameSize / 2, centerY - frameSize / 2 + bracketLength),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(centerX - frameSize / 2, centerY + frameSize / 2),
      Offset(centerX - frameSize / 2 + bracketLength, centerY + frameSize / 2),
      paint,
    );
    canvas.drawLine(
      Offset(centerX - frameSize / 2, centerY + frameSize / 2),
      Offset(centerX - frameSize / 2, centerY + frameSize / 2 - bracketLength),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(centerX + frameSize / 2, centerY + frameSize / 2),
      Offset(centerX + frameSize / 2 - bracketLength, centerY + frameSize / 2),
      paint,
    );
    canvas.drawLine(
      Offset(centerX + frameSize / 2, centerY + frameSize / 2),
      Offset(centerX + frameSize / 2, centerY + frameSize / 2 - bracketLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScratchPainter extends CustomPainter {
  final List<Offset> scratchPoints;

  ScratchPainter(this.scratchPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill;

    // Create scratch effect by drawing transparent circles at touch points
    for (int i = 0; i < scratchPoints.length; i++) {
      final point = scratchPoints[i];
      canvas.drawCircle(
        point,
        8.0, // Scratch radius
        paint..color = Colors.transparent,
      );
    }

    // Draw scratch lines between consecutive points
    if (scratchPoints.length > 1) {
      final linePaint =
          Paint()
            ..color = Colors.transparent
            ..strokeWidth = 6.0
            ..strokeCap = StrokeCap.round;

      for (int i = 1; i < scratchPoints.length; i++) {
        canvas.drawLine(scratchPoints[i - 1], scratchPoints[i], linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
