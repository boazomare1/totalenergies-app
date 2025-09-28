import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/support_service.dart';
import '../services/auth_service.dart';
import 'ticket_screen.dart';

class SupportCenterScreen extends StatefulWidget {
  const SupportCenterScreen({super.key});

  @override
  State<SupportCenterScreen> createState() => _SupportCenterScreenState();
}

class _SupportCenterScreenState extends State<SupportCenterScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _faqs = [];
  List<Map<String, dynamic>> _filteredFAQs = [];
  List<Map<String, dynamic>> _tickets = [];
  String _searchQuery = '';
  String _selectedCategory = 'all';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _faqs = SupportService.getAllFAQs();
      _filteredFAQs = _faqs;
      _tickets = SupportService.getUserTickets(
        'current_user',
      ); // In real app, get from auth
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredFAQs =
          _faqs.where((faq) {
            // Filter by category
            if (_selectedCategory != 'all' &&
                faq['category'] != _selectedCategory) {
              return false;
            }

            // Filter by search query
            if (_searchQuery.isNotEmpty) {
              final query = _searchQuery.toLowerCase();
              return faq['question'].toString().toLowerCase().contains(query) ||
                  faq['answer'].toString().toLowerCase().contains(query);
            }

            return true;
          }).toList();
    });
  }

  void _showCreateTicketDialog() {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'general';
    String selectedPriority = 'medium';

    // Pre-populate with user data if available
    final user = AuthService.getCurrentUser();
    if (user != null) {
      // You can add user-specific pre-filled data here if needed
    }

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: Text(
                    'Create Support Ticket',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: subjectController,
                          decoration: InputDecoration(
                            labelText: 'Subject',
                            hintText: 'Brief description of your issue',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items:
                              SupportService.getTicketCategories().map((
                                category,
                              ) {
                                final categoryNames =
                                    SupportService.getTicketCategoriesDisplayNames();
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    categoryNames[category] ?? category,
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items:
                              SupportService.getTicketPriorities().map((
                                priority,
                              ) {
                                final priorityNames =
                                    SupportService.getTicketPrioritiesDisplayNames();
                                return DropdownMenuItem(
                                  value: priority,
                                  child: Text(
                                    priorityNames[priority] ?? priority,
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPriority = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText:
                                'Please provide detailed information about your issue',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (subjectController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty) {
                          _createTicket(
                            subjectController.text,
                            descriptionController.text,
                            selectedCategory,
                            selectedPriority,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE60012),
                      ),
                      child: Text(
                        'Create Ticket',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  void _createTicket(
    String subject,
    String description,
    String category,
    String priority,
  ) {
    final result = SupportService.createTicket(
      userId: 'current_user', // In real app, get from auth service
      subject: subject,
      description: description,
      category: category,
      priority: priority,
    );

    if (result['success']) {
      setState(() {
        _tickets.insert(0, result['ticket']);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ticket created successfully!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'], style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLiveChatDialog() {
    final availability = SupportService.getLiveChatAvailability();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Live Chat',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  availability['isAvailable'] ? Icons.chat : Icons.schedule,
                  size: 48,
                  color:
                      availability['isAvailable']
                          ? Colors.green
                          : Colors.orange,
                ),
                const SizedBox(height: 16),
                Text(
                  availability['isAvailable']
                      ? 'Live chat is available now!'
                      : 'Live chat is not available at the moment.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (availability['isAvailable']) ...[
                  Text(
                    'Average wait time: ${availability['currentWaitTime']} minutes',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                  Text(
                    'Operators online: ${availability['operatorsOnline']}',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ] else ...[
                  Text(
                    'Available: 8 AM - 8 PM',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ),
              if (availability['isAvailable'])
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _startLiveChat();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE60012),
                  ),
                  child: Text(
                    'Start Chat',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
            ],
          ),
    );
  }

  void _startLiveChat() {
    final result = SupportService.startLiveChatSession('current_user');

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Live chat session started!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'], style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Support Center',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showLiveChatDialog,
            icon: const Icon(Icons.chat),
            tooltip: 'Live Chat',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.help_outline, size: 18),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'FAQs',
                      style: GoogleFonts.poppins(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.support_agent, size: 18),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Tickets',
                      style: GoogleFonts.poppins(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 18),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'New',
                      style: GoogleFonts.poppins(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFAQsTab(), _buildTicketsTab(), _buildNewTicketTab()],
      ),
    );
  }

  Widget _buildFAQsTab() {
    return Column(
      children: [
        // Search and Filter Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _applyFilters();
                },
                decoration: InputDecoration(
                  hintText: 'Search FAQs...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFE60012),
                  ),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                              _applyFilters();
                            },
                            icon: const Icon(Icons.clear, color: Colors.grey),
                          )
                          : null,
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
                    borderSide: const BorderSide(
                      color: Color(0xFFE60012),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 12),
              // Category Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('all', 'All'),
                    const SizedBox(width: 8),
                    ...SupportService.getFAQCategories().map((category) {
                      final categoryNames =
                          SupportService.getFAQCategoriesDisplayNames();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryChip(
                          category,
                          categoryNames[category]!,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        // FAQs List
        Expanded(
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFE60012)),
                  )
                  : _filteredFAQs.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No FAQs found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: GoogleFonts.poppins(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFAQs.length,
                    itemBuilder: (context, index) {
                      final faq = _filteredFAQs[index];
                      return _buildFAQCard(faq);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildTicketsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Support Tickets',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your support tickets and create new ones',
            style: GoogleFonts.poppins(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TicketScreen()),
              );
            },
            icon: const Icon(Icons.support_agent),
            label: Text(
              'Open Support Tickets',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE60012),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewTicketTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.support_agent,
                  title: 'Create Ticket',
                  subtitle: 'Get help with your issue',
                  onTap: _showCreateTicketDialog,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.chat,
                  title: 'Live Chat',
                  subtitle: 'Chat with support',
                  onTap: _showLiveChatDialog,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Contact Information
          Text(
            'Contact Information',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            icon: Icons.phone,
            title: 'Phone Support',
            subtitle: '+254 20 123 4567',
            action: 'Call Now',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Calling support...',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'support@totalenergies.co.ke',
            action: 'Send Email',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Opening email client...',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.schedule,
            title: 'Business Hours',
            subtitle: 'Monday - Friday: 8 AM - 8 PM\nSaturday: 9 AM - 5 PM',
            action: '',
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String value, String label) {
    final isSelected = _selectedCategory == value;
    return FilterChip(
      label: Text(label, style: GoogleFonts.poppins()),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = value;
        });
        _applyFilters();
      },
      selectedColor: const Color(0xFFE60012).withValues(alpha: 0.2),
      checkmarkColor: const Color(0xFFE60012),
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> faq) {
    final categoryNames = SupportService.getFAQCategoriesDisplayNames();
    final categoryIcons = SupportService.getFAQCategoriesIcons();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE60012).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    categoryIcons[faq['category']] ?? '❓',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    categoryNames[faq['category']] ?? faq['category'],
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: const Color(0xFFE60012),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  faq['helpful'].toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq['answer'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          SupportService.markFAQHelpful(faq['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Thank you for your feedback!',
                                style: GoogleFonts.poppins(),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.thumb_up, size: 16),
                        label: Text('Helpful', style: GoogleFonts.poppins()),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          SupportService.markFAQNotHelpful(faq['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Thank you for your feedback!',
                                style: GoogleFonts.poppins(),
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                        icon: const Icon(Icons.thumb_down, size: 16),
                        label: Text(
                          'Not Helpful',
                          style: GoogleFonts.poppins(),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange),
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
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: const Color(0xFFE60012)),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
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
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
    required VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 24, color: const Color(0xFFE60012)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (action.isNotEmpty)
                Text(
                  action,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFFE60012),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketDetailsSheet(Map<String, dynamic> ticket) {
    final statusNames = SupportService.getTicketStatusesDisplayNames();
    final categoryNames = SupportService.getTicketCategoriesDisplayNames();
    final priorityNames = SupportService.getTicketPrioritiesDisplayNames();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Ticket Header
          Row(
            children: [
              Expanded(
                child: Text(
                  ticket['subject'],
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusNames[ticket['status']] ?? ticket['status'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Ticket Info
          Row(
            children: [
              _buildInfoChip(
                'Category',
                categoryNames[ticket['category']] ?? ticket['category'],
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                'Priority',
                priorityNames[ticket['priority']] ?? ticket['priority'],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            'Description',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ticket['description'],
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          // Messages
          Text(
            'Messages',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: ticket['messages'].length,
              itemBuilder: (context, index) {
                final message = ticket['messages'][index];
                return _buildMessageBubble(message);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['sender'] == 'user';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFFE60012) : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['message'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isUser ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message['timestamp']),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isUser ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
