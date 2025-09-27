import 'package:shared_preferences/shared_preferences.dart';

class DashboardService {
  static const String _balanceKey = 'fuel_card_balance';
  static const String _transactionsKey = 'recent_transactions';
  static const String _cardNumberKey = 'card_number';

  // Get fuel card balance
  static Future<double> getFuelCardBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_balanceKey) ?? 0.0;
  }

  // Update fuel card balance
  static Future<void> updateFuelCardBalance(double newBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, newBalance);
  }

  // Get card number
  static Future<String> getCardNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cardNumberKey) ?? '**** **** **** 1234';
  }

  // Set card number
  static Future<void> setCardNumber(String cardNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cardNumberKey, cardNumber);
  }

  // Get recent transactions
  static Future<List<Map<String, dynamic>>> getRecentTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    
    // Parse transactions from JSON strings
    List<Map<String, dynamic>> transactions = [];
    for (String transactionJson in transactionsJson) {
      try {
        // Simple parsing - in real app would use proper JSON
        final parts = transactionJson.split('|');
        if (parts.length >= 4) {
          transactions.add({
            'id': parts[0],
            'type': parts[1],
            'amount': double.parse(parts[2]),
            'description': parts[3],
            'date': parts.length > 4 ? parts[4] : DateTime.now().toIso8601String(),
            'status': parts.length > 5 ? parts[5] : 'completed',
          });
        }
      } catch (e) {
        print('Error parsing transaction: $e');
      }
    }
    
    // Sort by date (newest first)
    transactions.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    
    return transactions.take(5).toList(); // Return only last 5
  }

  // Add a new transaction
  static Future<void> addTransaction({
    required String type,
    required double amount,
    required String description,
    String status = 'completed',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(_transactionsKey) ?? [];
    
    final transaction = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'amount': amount,
      'description': description,
      'date': DateTime.now().toIso8601String(),
      'status': status,
    };
    
    // Convert to string format for storage
    final transactionString = '${transaction['id']}|${transaction['type']}|${transaction['amount']}|${transaction['description']}|${transaction['date']}|${transaction['status']}';
    
    transactionsJson.insert(0, transactionString); // Add to beginning
    
    // Keep only last 20 transactions
    if (transactionsJson.length > 20) {
      transactionsJson.removeRange(20, transactionsJson.length);
    }
    
    await prefs.setStringList(_transactionsKey, transactionsJson);
  }

  // Get offers and promotions
  static List<Map<String, dynamic>> getOffers() {
    return [
      {
        'id': '1',
        'title': 'Fuel Discount',
        'description': 'Get 5% off on fuel purchases',
        'discount': '5%',
        'validUntil': '2024-12-31',
        'type': 'fuel',
        'isActive': true,
      },
      {
        'id': '2',
        'title': 'Lubricant Special',
        'description': 'Buy 2 get 1 free on all lubricants',
        'discount': '33%',
        'validUntil': '2024-11-30',
        'type': 'lubricant',
        'isActive': true,
      },
      {
        'id': '3',
        'title': 'Convenience Store',
        'description': '10% off on snacks and beverages',
        'discount': '10%',
        'validUntil': '2024-12-15',
        'type': 'convenience',
        'isActive': true,
      },
      {
        'id': '4',
        'title': 'Car Wash',
        'description': 'Free car wash with fuel purchase over KSh 2000',
        'discount': 'Free',
        'validUntil': '2024-12-20',
        'type': 'service',
        'isActive': true,
      },
    ];
  }

  // Get quick stats
  static Future<Map<String, dynamic>> getQuickStats() async {
    final balance = await getFuelCardBalance();
    final transactions = await getRecentTransactions();
    final offers = getOffers();
    
    // Calculate monthly spending
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final monthlySpending = transactions
        .where((t) => DateTime.parse(t['date']).isAfter(thisMonth))
        .fold(0.0, (sum, t) => sum + (t['amount'] as double));
    
    return {
      'balance': balance,
      'monthlySpending': monthlySpending,
      'activeOffers': offers.where((o) => o['isActive']).length,
      'recentTransactions': transactions.length,
    };
  }

  // Initialize with sample data
  static Future<void> initializeSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Set initial balance if not set
    if (!prefs.containsKey(_balanceKey)) {
      await updateFuelCardBalance(2500.0);
    }
    
    // Set card number if not set
    if (!prefs.containsKey(_cardNumberKey)) {
      await setCardNumber('**** **** **** 1234');
    }
    
    // Add sample transactions if none exist
    final existingTransactions = prefs.getStringList(_transactionsKey) ?? [];
    if (existingTransactions.isEmpty) {
      await addTransaction(
        type: 'topup',
        amount: 1000.0,
        description: 'Card Top-up via M-Pesa',
      );
      
      await addTransaction(
        type: 'fuel',
        amount: -450.0,
        description: 'Fuel Purchase - Station 001',
      );
      
      await addTransaction(
        type: 'fuel',
        amount: -320.0,
        description: 'Fuel Purchase - Station 045',
      );
      
      await addTransaction(
        type: 'topup',
        amount: 500.0,
        description: 'Card Top-up via Visa',
      );
      
      await addTransaction(
        type: 'fuel',
        amount: -280.0,
        description: 'Fuel Purchase - Station 012',
      );
    }
  }
}