import '../services/hive_database_service.dart';

class UserBalanceService {
  static final UserBalanceService _instance = UserBalanceService._internal();
  factory UserBalanceService() => _instance;
  UserBalanceService._internal();

  /// Get user's current balance
  Future<double> getBalance(String userId) async {
    try {
      return await HiveDatabaseService.getUserBalance(userId);
    } catch (e) {
      print('Error getting user balance: $e');
      return 0.0;
    }
  }

  /// Add funds to user's balance
  Future<void> addFunds(String userId, double amount) async {
    try {
      if (amount <= 0) {
        throw Exception('Amount must be positive');
      }

      await HiveDatabaseService.addToUserBalance(userId, amount);
      print('Added $amount to user balance: $userId');
    } catch (e) {
      print('Error adding funds: $e');
      rethrow;
    }
  }

  /// Deduct funds from user's balance
  Future<bool> deductFunds(String userId, double amount) async {
    try {
      if (amount <= 0) {
        throw Exception('Amount must be positive');
      }

      return await HiveDatabaseService.deductFromUserBalance(userId, amount);
    } catch (e) {
      print('Error deducting funds: $e');
      return false;
    }
  }

  /// Set user's balance to a specific amount
  Future<void> setBalance(String userId, double amount) async {
    try {
      if (amount < 0) {
        throw Exception('Balance cannot be negative');
      }

      await HiveDatabaseService.updateUserBalance(userId, amount);
      print('Set user balance to $amount: $userId');
    } catch (e) {
      print('Error setting balance: $e');
      rethrow;
    }
  }

  /// Check if user has sufficient balance for a transaction
  Future<bool> hasSufficientBalance(String userId, double amount) async {
    try {
      final balance = await getBalance(userId);
      return balance >= amount;
    } catch (e) {
      print('Error checking balance: $e');
      return false;
    }
  }

  /// Process payment for an order
  Future<bool> processPayment(
    String userId,
    double amount,
    String orderId,
  ) async {
    try {
      final hasBalance = await hasSufficientBalance(userId, amount);

      if (!hasBalance) {
        print('Insufficient balance for order: $orderId');
        return false;
      }

      final success = await deductFunds(userId, amount);

      if (success) {
        print('Payment processed successfully for order: $orderId');
        // Here you could add transaction logging
        await _logTransaction(userId, -amount, 'Payment for order $orderId');
      }

      return success;
    } catch (e) {
      print('Error processing payment: $e');
      return false;
    }
  }

  /// Add refund to user's balance
  Future<void> processRefund(
    String userId,
    double amount,
    String orderId,
  ) async {
    try {
      await addFunds(userId, amount);
      await _logTransaction(userId, amount, 'Refund for order $orderId');
      print('Refund processed successfully for order: $orderId');
    } catch (e) {
      print('Error processing refund: $e');
      rethrow;
    }
  }

  /// Get transaction history (stored in user preferences for now)
  Future<List<Map<String, dynamic>>> getTransactionHistory(
    String userId,
  ) async {
    try {
      final user = await HiveDatabaseService.getUserById(userId);
      if (user != null) {
        return List<Map<String, dynamic>>.from(
          user.preferences['transactions'] ?? [],
        );
      }
      return [];
    } catch (e) {
      print('Error getting transaction history: $e');
      return [];
    }
  }

  /// Log a transaction
  Future<void> _logTransaction(
    String userId,
    double amount,
    String description,
  ) async {
    try {
      final user = await HiveDatabaseService.getUserById(userId);
      if (user != null) {
        final transactions = List<Map<String, dynamic>>.from(
          user.preferences['transactions'] ?? [],
        );

        transactions.insert(0, {
          'amount': amount,
          'description': description,
          'timestamp': DateTime.now().toIso8601String(),
          'balance': user.cardBalance,
        });

        // Keep only last 50 transactions
        if (transactions.length > 50) {
          transactions.removeRange(50, transactions.length);
        }

        user.preferences['transactions'] = transactions;
        await HiveDatabaseService.updateUser(user);
      }
    } catch (e) {
      print('Error logging transaction: $e');
    }
  }

  /// Get balance summary with recent transactions
  Future<Map<String, dynamic>> getBalanceSummary(String userId) async {
    try {
      final balance = await getBalance(userId);
      final transactions = await getTransactionHistory(userId);

      return {
        'currentBalance': balance,
        'recentTransactions': transactions.take(10).toList(),
        'totalTransactions': transactions.length,
      };
    } catch (e) {
      print('Error getting balance summary: $e');
      return {
        'currentBalance': 0.0,
        'recentTransactions': [],
        'totalTransactions': 0,
      };
    }
  }
}
