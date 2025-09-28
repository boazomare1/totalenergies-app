import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCategory = 'General';
  String _selectedPriority = 'Medium';
  List<Map<String, dynamic>> _tickets = [];
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General',
    'Technical Issue',
    'Payment Problem',
    'Station Issue',
    'Account Problem',
    'Other',
  ];

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTickets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadTickets() {
    // Simulate loading tickets
    setState(() {
      _tickets = [
        {
          'id': 'TKT-001',
          'subject': 'Payment not processed',
          'category': 'Payment Problem',
          'priority': 'High',
          'status': 'Open',
          'createdAt': DateTime.now().subtract(const Duration(days: 2)),
          'description': 'My payment was deducted but not reflected in my account balance.',
        },
        {
          'id': 'TKT-002',
          'subject': 'Station locator not working',
          'category': 'Technical Issue',
          'priority': 'Medium',
          'status': 'In Progress',
          'createdAt': DateTime.now().subtract(const Duration(days: 1)),
          'description': 'The station locator shows incorrect locations.',
        },
        {
          'id': 'TKT-003',
          'subject': 'Account login issue',
          'category': 'Account Problem',
          'priority': 'Low',
          'status': 'Resolved',
          'createdAt': DateTime.now().subtract(const Duration(days: 5)),
          'description': 'Unable to login with biometric authentication.',
        },
      ];
    });
  }

  void _createTicket() {
    if (_subjectController.text.isEmpty || _descriptionController.text.isEmpty) {
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

    setState(() {
      _isSubmitting = true;
    });

    // Simulate ticket creation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _tickets.insert(0, {
            'id': 'TKT-${_tickets.length + 1}',
            'subject': _subjectController.text,
            'category': _selectedCategory,
            'priority': _selectedPriority,
            'status': 'Open',
            'createdAt': DateTime.now(),
            'description': _descriptionController.text,
          });
        });

        _subjectController.clear();
        _descriptionController.clear();
        _phoneController.clear();
        _selectedCategory = 'General';
        _selectedPriority = 'Medium';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ticket created successfully!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );

        _tabController.animateTo(0); // Switch to tickets list
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Support Tickets',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE60012),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              child: Text(
                'My Tickets',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              child: Text(
                'Create Ticket',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTicketsList(),
          _buildCreateTicketForm(),
        ],
      ),
    );
  }

  Widget _buildTicketsList() {
    if (_tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tickets yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first support ticket',
              style: GoogleFonts.poppins(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        final ticket = _tickets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              ticket['subject'],
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  ticket['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusChip(ticket['status']),
                    const SizedBox(width: 8),
                    _buildPriorityChip(ticket['priority']),
                    const Spacer(),
                    Text(
                      ticket['id'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
            onTap: () => _showTicketDetails(ticket),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor(status)),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor(priority).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getPriorityColor(priority)),
      ),
      child: Text(
        priority,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _getPriorityColor(priority),
        ),
      ),
    );
  }

  Widget _buildCreateTicketForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Support Ticket',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Category Selection
          Text(
            'Category *',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category, style: GoogleFonts.poppins()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          const SizedBox(height: 16),

          // Priority Selection
          Text(
            'Priority *',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedPriority,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: _priorities.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Text(priority, style: GoogleFonts.poppins()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPriority = value!;
              });
            },
          ),
          const SizedBox(height: 16),

          // Subject
          Text(
            'Subject *',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'Brief description of your issue',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Description *',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Please provide detailed information about your issue',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),

          // Phone (Optional)
          Text(
            'Phone Number (Optional)',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'For callback if needed',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _createTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Create Ticket',
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
    );
  }

  void _showTicketDetails(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ticket Details',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              ticket['subject'],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${ticket['id']}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatusChip(ticket['status']),
                const SizedBox(width: 8),
                _buildPriorityChip(ticket['priority']),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              ticket['description'],
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 16),
            Text(
              'Created: ${_formatDate(ticket['createdAt'])}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60012),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}