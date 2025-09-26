import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _filteredNotifications = [];
  String _selectedFilter = 'all'; // all, unread, read

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _searchController.addListener(_filterNotifications);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    _notifications = [
      {
        'id': '1',
        'title': 'Payment Successful',
        'message': 'Your card top-up of KSh 1,000 via M-Pesa was successful',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'isRead': false,
        'type': 'payment',
        'priority': 'high',
      },
      {
        'id': '2',
        'title': 'New Offer Available',
        'message': 'Get 10% off on Quartz engine oil this weekend!',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'type': 'promotion',
        'priority': 'medium',
      },
      {
        'id': '3',
        'title': 'Station Update',
        'message': 'TotalEnergies Station on Mombasa Road is now open 24/7',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
        'isRead': true,
        'type': 'station',
        'priority': 'low',
      },
      {
        'id': '4',
        'title': 'Card Application Approved',
        'message':
            'Your virtual card application has been approved and is ready to use',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
        'type': 'card',
        'priority': 'high',
      },
      {
        'id': '5',
        'title': 'Maintenance Notice',
        'message':
            'Scheduled maintenance on our mobile app tonight from 2-4 AM',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'isRead': true,
        'type': 'system',
        'priority': 'medium',
      },
      {
        'id': '6',
        'title': 'Welcome to TotalEnergies',
        'message':
            'Thank you for downloading our app! Explore our services and offers',
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
        'isRead': true,
        'type': 'welcome',
        'priority': 'low',
      },
      {
        'id': '7',
        'title': 'Fuel Price Update',
        'message':
            'Petrol prices have been updated. Check the latest rates in Station Finder',
        'timestamp': DateTime.now().subtract(const Duration(days: 4)),
        'isRead': false,
        'type': 'fuel',
        'priority': 'medium',
      },
      {
        'id': '8',
        'title': 'Order Delivered',
        'message':
            'Your Total Gas cylinder order has been delivered successfully',
        'timestamp': DateTime.now().subtract(const Duration(days: 5)),
        'isRead': true,
        'type': 'delivery',
        'priority': 'high',
      },
    ];
    _filterNotifications();
  }

  void _filterNotifications() {
    setState(() {
      _filteredNotifications =
          _notifications.where((notification) {
            final matchesSearch =
                _searchController.text.isEmpty ||
                notification['title'].toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                notification['message'].toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

            final matchesFilter =
                _selectedFilter == 'all' ||
                (_selectedFilter == 'unread' && !notification['isRead']) ||
                (_selectedFilter == 'read' && notification['isRead']);

            return matchesSearch && matchesFilter;
          }).toList();

      // Sort by timestamp (newest first)
      _filteredNotifications.sort(
        (a, b) => b['timestamp'].compareTo(a['timestamp']),
      );
    });
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
    _filterNotifications();
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    _filterNotifications();
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
    _filterNotifications();
  }

  void _deleteAllRead() {
    setState(() {
      _notifications.removeWhere((n) => n['isRead']);
    });
    _filterNotifications();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.payment;
      case 'promotion':
        return Icons.local_offer;
      case 'station':
        return Icons.location_on;
      case 'card':
        return Icons.credit_card;
      case 'system':
        return Icons.settings;
      case 'welcome':
        return Icons.waving_hand;
      case 'fuel':
        return Icons.local_gas_station;
      case 'delivery':
        return Icons.delivery_dining;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFE60012),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: _markAllAsRead,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFE60012),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  'Mark All Read',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete_all_read') {
                _deleteAllRead();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'delete_all_read',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_sweep,
                          color: Colors.red[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text('Delete All Read', style: GoogleFonts.poppins()),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notifications...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[600]),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE60012)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all', _notifications.length),
                      const SizedBox(width: 8),
                      _buildFilterChip('Unread', 'unread', unreadCount),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        'Read',
                        'read',
                        _notifications.length - unreadCount,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Notifications List
          Expanded(
            child:
                _filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        _filterNotifications();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE60012) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFE60012),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: GoogleFonts.poppins(
                    color: isSelected ? const Color(0xFFE60012) : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final priority = notification['priority'] as String;
    final type = notification['type'] as String;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isRead
                  ? Colors.grey[200]!
                  : const Color(0xFFE60012).withValues(alpha: 0.3),
          width: isRead ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getPriorityColor(priority).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(type),
                color: _getPriorityColor(priority),
                size: 20,
              ),
            ),
            if (!isRead)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE60012),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          notification['title'],
          style: GoogleFonts.poppins(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _formatTimestamp(notification['timestamp']),
                  style: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                if (!isRead)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE60012),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'NEW',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'mark_read' && !isRead) {
              _markAsRead(notification['id']);
            } else if (value == 'delete') {
              _deleteNotification(notification['id']);
            }
          },
          itemBuilder:
              (context) => [
                if (!isRead)
                  PopupMenuItem(
                    value: 'mark_read',
                    child: Row(
                      children: [
                        Icon(
                          Icons.mark_email_read,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text('Mark as Read', style: GoogleFonts.poppins()),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red[600], size: 20),
                      const SizedBox(width: 8),
                      Text('Delete', style: GoogleFonts.poppins()),
                    ],
                  ),
                ),
              ],
        ),
        onTap: () {
          if (!isRead) {
            _markAsRead(notification['id']);
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isNotEmpty
                ? 'No notifications found'
                : 'No notifications',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'You\'re all caught up!',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60012),
                foregroundColor: Colors.white,
              ),
              child: Text('Clear Search', style: GoogleFonts.poppins()),
            ),
          ],
        ],
      ),
    );
  }
}
