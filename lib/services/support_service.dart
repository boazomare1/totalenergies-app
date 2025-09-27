class SupportService {
  // Sample FAQ data
  static final List<Map<String, dynamic>> _faqs = [
    {
      'id': '1',
      'category': 'general',
      'question': 'How do I top up my TotalEnergies card?',
      'answer': 'You can top up your card using M-Pesa, Visa/Mastercard, or Bank Transfer. Go to the "My Card" section and tap "Top Up" to choose your preferred payment method.',
      'tags': ['card', 'topup', 'payment'],
      'helpful': 45,
      'notHelpful': 2,
    },
    {
      'id': '2',
      'category': 'general',
      'question': 'What payment methods are accepted?',
      'answer': 'We accept M-Pesa mobile money, Visa/Mastercard credit/debit cards, and Bank Transfer. All payments are processed securely with OTP verification.',
      'tags': ['payment', 'security', 'otp'],
      'helpful': 38,
      'notHelpful': 1,
    },
    {
      'id': '3',
      'category': 'card',
      'question': 'How do I check my card balance?',
      'answer': 'Your card balance is displayed on the home screen. You can also view detailed balance information in the "My Card" section.',
      'tags': ['balance', 'card', 'home'],
      'helpful': 52,
      'notHelpful': 0,
    },
    {
      'id': '4',
      'category': 'card',
      'question': 'What if my card is lost or stolen?',
      'answer': 'Contact our support immediately. We will block your card and issue a replacement. You can also report it through the app in the "Support" section.',
      'tags': ['lost', 'stolen', 'replacement', 'security'],
      'helpful': 29,
      'notHelpful': 3,
    },
    {
      'id': '5',
      'category': 'stations',
      'question': 'How do I find the nearest TotalEnergies station?',
      'answer': 'Use the "Stations" tab to find nearby stations. The app will show you the closest stations with directions and available services.',
      'tags': ['stations', 'location', 'directions'],
      'helpful': 41,
      'notHelpful': 1,
    },
    {
      'id': '6',
      'category': 'stations',
      'question': 'Do all stations have EV charging?',
      'answer': 'Not all stations have EV charging. Use the station filter to find stations with EV charging facilities. Look for the EV charging icon in the station list.',
      'tags': ['ev', 'charging', 'stations', 'filter'],
      'helpful': 23,
      'notHelpful': 2,
    },
    {
      'id': '7',
      'category': 'promotions',
      'question': 'How do I redeem a promotion?',
      'answer': 'Go to the "Promotions" section, select a promotion, and tap "Redeem". You can also scan QR codes at the station to redeem promotions.',
      'tags': ['promotions', 'redeem', 'qr', 'discount'],
      'helpful': 34,
      'notHelpful': 1,
    },
    {
      'id': '8',
      'category': 'promotions',
      'question': 'Are promotions valid at all stations?',
      'answer': 'Some promotions are valid at all stations, while others are location-specific. Check the promotion details for validity information.',
      'tags': ['promotions', 'validity', 'location', 'stations'],
      'helpful': 19,
      'notHelpful': 4,
    },
    {
      'id': '9',
      'category': 'products',
      'question': 'Can I pre-order products?',
      'answer': 'Yes, you can pre-order many products through the "Products" section. Select a product and choose "Pre-order" to schedule pickup.',
      'tags': ['products', 'preorder', 'reservation'],
      'helpful': 27,
      'notHelpful': 2,
    },
    {
      'id': '10',
      'category': 'products',
      'question': 'What products are available at TotalEnergies stations?',
      'answer': 'We offer fuel, lubricants, car care products, convenience store items, and services like car wash and EV charging. Check the Products section for details.',
      'tags': ['products', 'fuel', 'lubricants', 'services'],
      'helpful': 31,
      'notHelpful': 1,
    },
    {
      'id': '11',
      'category': 'technical',
      'question': 'The app is not working properly. What should I do?',
      'answer': 'Try closing and reopening the app. If the problem persists, check your internet connection or contact our support team for assistance.',
      'tags': ['technical', 'app', 'bug', 'support'],
      'helpful': 18,
      'notHelpful': 5,
    },
    {
      'id': '12',
      'category': 'technical',
      'question': 'How do I update the app?',
      'answer': 'Go to your app store (Google Play Store or Apple App Store) and check for updates. Enable automatic updates for the best experience.',
      'tags': ['update', 'app', 'store', 'technical'],
      'helpful': 22,
      'notHelpful': 1,
    },
  ];

  // Sample support tickets
  static final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'TKT001',
      'userId': 'user123',
      'subject': 'Card top-up failed',
      'description': 'I tried to top up my card with KSh 1000 but the transaction failed. The money was deducted from my M-Pesa but the card balance was not updated.',
      'category': 'payment',
      'priority': 'high',
      'status': 'open',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      'updatedAt': DateTime.now().subtract(const Duration(hours: 2)),
      'assignedTo': 'support_team',
      'attachments': [],
      'messages': [
        {
          'id': '1',
          'sender': 'user',
          'message': 'I tried to top up my card with KSh 1000 but the transaction failed. The money was deducted from my M-Pesa but the card balance was not updated.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'isRead': true,
        },
        {
          'id': '2',
          'sender': 'support',
          'message': 'Thank you for contacting us. We have received your ticket and are investigating the issue. We will get back to you within 24 hours.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          'isRead': true,
        },
      ],
    },
    {
      'id': 'TKT002',
      'userId': 'user456',
      'subject': 'Station not found on map',
      'description': 'I cannot find the TotalEnergies station near my location on the map. The station exists but is not showing up in the app.',
      'category': 'stations',
      'priority': 'medium',
      'status': 'in_progress',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      'updatedAt': DateTime.now().subtract(const Duration(hours: 6)),
      'assignedTo': 'support_team',
      'attachments': [],
      'messages': [
        {
          'id': '1',
          'sender': 'user',
          'message': 'I cannot find the TotalEnergies station near my location on the map. The station exists but is not showing up in the app.',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'isRead': true,
        },
        {
          'id': '2',
          'sender': 'support',
          'message': 'We are looking into this issue. Could you please provide the exact location or address of the station?',
          'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
          'isRead': true,
        },
        {
          'id': '3',
          'sender': 'user',
          'message': 'The station is located on Mombasa Road, near the Industrial Area. The address is TotalEnergies Mombasa Road Station.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
          'isRead': true,
        },
      ],
    },
    {
      'id': 'TKT003',
      'userId': 'user789',
      'subject': 'Promotion not working',
      'description': 'I tried to redeem a fuel discount promotion but it did not work. The QR code was scanned but no discount was applied.',
      'category': 'promotions',
      'priority': 'medium',
      'status': 'resolved',
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      'updatedAt': DateTime.now().subtract(const Duration(days: 1)),
      'assignedTo': 'support_team',
      'attachments': [],
      'messages': [
        {
          'id': '1',
          'sender': 'user',
          'message': 'I tried to redeem a fuel discount promotion but it did not work. The QR code was scanned but no discount was applied.',
          'timestamp': DateTime.now().subtract(const Duration(days: 3)),
          'isRead': true,
        },
        {
          'id': '2',
          'sender': 'support',
          'message': 'We apologize for the inconvenience. The promotion has been fixed and you should now be able to redeem it. Please try again.',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'isRead': true,
        },
      ],
    },
  ];

  // Get all FAQs
  static List<Map<String, dynamic>> getAllFAQs() {
    return List.from(_faqs);
  }

  // Get FAQs by category
  static List<Map<String, dynamic>> getFAQsByCategory(String category) {
    return _faqs.where((faq) {
      return faq['category'] == category;
    }).toList();
  }

  // Search FAQs
  static List<Map<String, dynamic>> searchFAQs(String query) {
    if (query.isEmpty) return _faqs;
    
    final lowercaseQuery = query.toLowerCase();
    return _faqs.where((faq) {
      return faq['question'].toString().toLowerCase().contains(lowercaseQuery) ||
             faq['answer'].toString().toLowerCase().contains(lowercaseQuery) ||
             (faq['tags'] as List).any((tag) => tag.toString().toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Get FAQ by ID
  static Map<String, dynamic>? getFAQById(String id) {
    try {
      return _faqs.firstWhere((faq) => faq['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Mark FAQ as helpful
  static void markFAQHelpful(String faqId) {
    final faq = getFAQById(faqId);
    if (faq != null) {
      faq['helpful'] = (faq['helpful'] as int) + 1;
    }
  }

  // Mark FAQ as not helpful
  static void markFAQNotHelpful(String faqId) {
    final faq = getFAQById(faqId);
    if (faq != null) {
      faq['notHelpful'] = (faq['notHelpful'] as int) + 1;
    }
  }

  // Get FAQ categories
  static List<String> getFAQCategories() {
    final categories = <String>{};
    for (final faq in _faqs) {
      categories.add(faq['category']);
    }
    return categories.toList()..sort();
  }

  // Get FAQ category display names
  static Map<String, String> getFAQCategoriesDisplayNames() {
    return {
      'general': 'General',
      'card': 'Card & Payments',
      'stations': 'Stations & Locations',
      'promotions': 'Promotions & Offers',
      'products': 'Products & Services',
      'technical': 'Technical Support',
    };
  }

  // Get FAQ category icons
  static Map<String, String> getFAQCategoriesIcons() {
    return {
      'general': '❓',
      'card': '💳',
      'stations': '📍',
      'promotions': '🎁',
      'products': '📦',
      'technical': '🔧',
    };
  }

  // Get user tickets
  static List<Map<String, dynamic>> getUserTickets(String userId) {
    return _tickets.where((ticket) {
      return ticket['userId'] == userId;
    }).toList();
  }

  // Get ticket by ID
  static Map<String, dynamic>? getTicketById(String id) {
    try {
      return _tickets.firstWhere((ticket) => ticket['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Create new ticket
  static Map<String, dynamic> createTicket({
    required String userId,
    required String subject,
    required String description,
    required String category,
    String priority = 'medium',
    List<String>? attachments,
  }) {
    final ticketId = 'TKT${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    
    final ticket = {
      'id': ticketId,
      'userId': userId,
      'subject': subject,
      'description': description,
      'category': category,
      'priority': priority,
      'status': 'open',
      'createdAt': now,
      'updatedAt': now,
      'assignedTo': 'support_team',
      'attachments': attachments ?? [],
      'messages': [
        {
          'id': '1',
          'sender': 'user',
          'message': description,
          'timestamp': now,
          'isRead': true,
        },
      ],
    };
    
    _tickets.add(ticket);
    
    return {
      'success': true,
      'message': 'Ticket created successfully',
      'ticketId': ticketId,
      'ticket': ticket,
    };
  }

  // Add message to ticket
  static Map<String, dynamic> addMessageToTicket({
    required String ticketId,
    required String sender,
    required String message,
  }) {
    final ticket = getTicketById(ticketId);
    
    if (ticket == null) {
      return {
        'success': false,
        'message': 'Ticket not found',
      };
    }

    final messageId = (ticket['messages'] as List).length + 1;
    final newMessage = {
      'id': messageId.toString(),
      'sender': sender,
      'message': message,
      'timestamp': DateTime.now(),
      'isRead': false,
    };
    
    ticket['messages'].add(newMessage);
    ticket['updatedAt'] = DateTime.now();
    
    return {
      'success': true,
      'message': 'Message added successfully',
      'message': newMessage,
    };
  }

  // Update ticket status
  static Map<String, dynamic> updateTicketStatus({
    required String ticketId,
    required String status,
  }) {
    final ticket = getTicketById(ticketId);
    
    if (ticket == null) {
      return {
        'success': false,
        'message': 'Ticket not found',
      };
    }

    ticket['status'] = status;
    ticket['updatedAt'] = DateTime.now();
    
    return {
      'success': true,
      'message': 'Ticket status updated successfully',
    };
  }

  // Get ticket categories
  static List<String> getTicketCategories() {
    return [
      'payment',
      'card',
      'stations',
      'promotions',
      'products',
      'technical',
      'general',
    ];
  }

  // Get ticket category display names
  static Map<String, String> getTicketCategoriesDisplayNames() {
    return {
      'payment': 'Payment Issues',
      'card': 'Card Problems',
      'stations': 'Station Issues',
      'promotions': 'Promotion Problems',
      'products': 'Product Issues',
      'technical': 'Technical Support',
      'general': 'General Inquiry',
    };
  }

  // Get ticket priorities
  static List<String> getTicketPriorities() {
    return ['low', 'medium', 'high', 'urgent'];
  }

  // Get ticket priority display names
  static Map<String, String> getTicketPrioritiesDisplayNames() {
    return {
      'low': 'Low',
      'medium': 'Medium',
      'high': 'High',
      'urgent': 'Urgent',
    };
  }

  // Get ticket statuses
  static List<String> getTicketStatuses() {
    return ['open', 'in_progress', 'resolved', 'closed'];
  }

  // Get ticket status display names
  static Map<String, String> getTicketStatusesDisplayNames() {
    return {
      'open': 'Open',
      'in_progress': 'In Progress',
      'resolved': 'Resolved',
      'closed': 'Closed',
    };
  }

  // Get support statistics
  static Map<String, dynamic> getSupportStats() {
    final totalTickets = _tickets.length;
    final openTickets = _tickets.where((t) => t['status'] == 'open').length;
    final inProgressTickets = _tickets.where((t) => t['status'] == 'in_progress').length;
    final resolvedTickets = _tickets.where((t) => t['status'] == 'resolved').length;
    
    return {
      'totalTickets': totalTickets,
      'openTickets': openTickets,
      'inProgressTickets': inProgressTickets,
      'resolvedTickets': resolvedTickets,
      'totalFAQs': _faqs.length,
      'byCategory': {
        for (final category in getTicketCategories())
          category: _tickets.where((t) => t['category'] == category).length,
      },
    };
  }

  // Get live chat availability
  static Map<String, dynamic> getLiveChatAvailability() {
    // Simulate live chat availability
    final now = DateTime.now();
    final hour = now.hour;
    
    // Available 8 AM to 8 PM
    final isAvailable = hour >= 8 && hour < 20;
    
    return {
      'isAvailable': isAvailable,
      'nextAvailable': isAvailable ? null : DateTime(now.year, now.month, now.day, 8),
      'currentWaitTime': isAvailable ? 5 : 0, // minutes
      'operatorsOnline': isAvailable ? 3 : 0,
    };
  }

  // Start live chat session
  static Map<String, dynamic> startLiveChatSession(String userId) {
    final availability = getLiveChatAvailability();
    
    if (!availability['isAvailable']) {
      return {
        'success': false,
        'message': 'Live chat is not available at the moment. Please try again during business hours (8 AM - 8 PM).',
      };
    }

    final sessionId = 'CHAT${DateTime.now().millisecondsSinceEpoch}';
    
    return {
      'success': true,
      'message': 'Live chat session started',
      'sessionId': sessionId,
      'waitTime': availability['currentWaitTime'],
    };
  }
}