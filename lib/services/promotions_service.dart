
class PromotionsService {
  // Sample promotions data
  static final List<Map<String, dynamic>> _promotions = [
    {
      'id': '1',
      'title': 'Fuel Discount Weekend',
      'description': 'Get 5% off on all fuel purchases this weekend',
      'discount': 5.0,
      'type': 'fuel_discount',
      'validFrom': DateTime.now().subtract(const Duration(days: 1)),
      'validUntil': DateTime.now().add(const Duration(days: 2)),
      'isActive': true,
      'imageUrl': 'assets/images/promotions/fuel_discount.png',
      'qrCode': 'FUEL2024WEEKEND',
      'terms': 'Valid on weekends only. Maximum discount KSh 500.',
      'targetAudience': 'all',
      'priority': 'high',
      'isLocationBased': false,
      'requiredServices': ['fuel'],
    },
    {
      'id': '2',
      'title': 'Car Wash Combo',
      'description': 'Free car wash with fuel purchase above KSh 2000',
      'discount': 0.0,
      'type': 'combo_offer',
      'validFrom': DateTime.now().subtract(const Duration(days: 5)),
      'validUntil': DateTime.now().add(const Duration(days: 10)),
      'isActive': true,
      'imageUrl': 'assets/images/promotions/car_wash_combo.png',
      'qrCode': 'CARWASH2024',
      'terms': 'Valid with fuel purchase above KSh 2000. One per customer.',
      'targetAudience': 'all',
      'priority': 'medium',
      'isLocationBased': false,
      'requiredServices': ['fuel', 'car_wash'],
    },
    {
      'id': '3',
      'title': 'EV Charging Special',
      'description': '50% off on EV charging for first-time users',
      'discount': 50.0,
      'type': 'ev_charging',
      'validFrom': DateTime.now().subtract(const Duration(days: 2)),
      'validUntil': DateTime.now().add(const Duration(days: 30)),
      'isActive': true,
      'imageUrl': 'assets/images/promotions/ev_charging.png',
      'qrCode': 'EV2024FIRST',
      'terms': 'Valid for first-time EV charging users only.',
      'targetAudience': 'ev_users',
      'priority': 'high',
      'isLocationBased': true,
      'requiredServices': ['ev_charging'],
    },
    {
      'id': '4',
      'title': 'Loyalty Points Bonus',
      'description': 'Double loyalty points on all purchases this month',
      'discount': 0.0,
      'type': 'loyalty_bonus',
      'validFrom': DateTime.now().subtract(const Duration(days: 10)),
      'validUntil': DateTime.now().add(const Duration(days: 20)),
      'isActive': true,
      'imageUrl': 'assets/images/promotions/loyalty_bonus.png',
      'qrCode': 'LOYALTY2024BONUS',
      'terms': 'Double points on all purchases. Points expire in 6 months.',
      'targetAudience': 'loyalty_members',
      'priority': 'medium',
      'isLocationBased': false,
      'requiredServices': [],
    },
    {
      'id': '5',
      'title': 'Convenience Store Sale',
      'description': '20% off on all snacks and beverages',
      'discount': 20.0,
      'type': 'shop_discount',
      'validFrom': DateTime.now().subtract(const Duration(days: 3)),
      'validUntil': DateTime.now().add(const Duration(days: 7)),
      'isActive': true,
      'imageUrl': 'assets/images/promotions/shop_sale.png',
      'qrCode': 'SHOP2024SALE',
      'terms': 'Valid on snacks and beverages only. Excludes tobacco and alcohol.',
      'targetAudience': 'all',
      'priority': 'low',
      'isLocationBased': false,
      'requiredServices': ['shop'],
    },
    {
      'id': '6',
      'title': 'Nakuru Station Special',
      'description': 'Free coffee with any purchase at Nakuru station',
      'discount': 0.0,
      'type': 'location_specific',
      'validFrom': DateTime.now().subtract(const Duration(days: 1)),
      'validUntil': DateTime.now().add(const Duration(days: 5)),
      'isActive': true,
      'imageUrl': 'assets/images/promotions/nakuru_coffee.png',
      'qrCode': 'NAKURU2024COFFEE',
      'terms': 'Valid only at TotalEnergies Nakuru station.',
      'targetAudience': 'all',
      'priority': 'medium',
      'isLocationBased': true,
      'requiredServices': [],
      'locationId': '4', // Nakuru station ID
    },
  ];

  // Get all active promotions
  static List<Map<String, dynamic>> getActivePromotions() {
    final now = DateTime.now();
    return _promotions.where((promotion) {
      return promotion['isActive'] == true &&
             now.isAfter(promotion['validFrom']) &&
             now.isBefore(promotion['validUntil']);
    }).toList();
  }

  // Get promotions by type
  static List<Map<String, dynamic>> getPromotionsByType(String type) {
    return getActivePromotions().where((promotion) {
      return promotion['type'] == type;
    }).toList();
  }

  // Get location-based promotions
  static List<Map<String, dynamic>> getLocationBasedPromotions(String? locationId) {
    return getActivePromotions().where((promotion) {
      return promotion['isLocationBased'] == true &&
             (locationId == null || promotion['locationId'] == locationId);
    }).toList();
  }

  // Get promotions for user
  static List<Map<String, dynamic>> getPromotionsForUser({
    String? userType,
    String? locationId,
    List<String>? availableServices,
  }) {
    return getActivePromotions().where((promotion) {
      // Check target audience
      if (promotion['targetAudience'] != 'all' && 
          promotion['targetAudience'] != userType) {
        return false;
      }

      // Check location-based promotions
      if (promotion['isLocationBased'] == true && 
          promotion['locationId'] != locationId) {
        return false;
      }

      // Check required services
      if (promotion['requiredServices'] != null && 
          promotion['requiredServices'].isNotEmpty) {
        final requiredServices = List<String>.from(promotion['requiredServices']);
        if (availableServices == null || 
            !requiredServices.every((service) => availableServices.contains(service))) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Get promotion by ID
  static Map<String, dynamic>? getPromotionById(String id) {
    try {
      return _promotions.firstWhere((promotion) => promotion['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Redeem promotion
  static Map<String, dynamic> redeemPromotion({
    required String promotionId,
    required String userId,
    required String stationId,
    double? purchaseAmount,
  }) {
    final promotion = getPromotionById(promotionId);
    
    if (promotion == null) {
      return {
        'success': false,
        'message': 'Promotion not found',
      };
    }

    // Check if promotion is still valid
    final now = DateTime.now();
    if (!now.isAfter(promotion['validFrom']) || 
        !now.isBefore(promotion['validUntil'])) {
      return {
        'success': false,
        'message': 'Promotion has expired',
      };
    }

    // Check if promotion is active
    if (promotion['isActive'] != true) {
      return {
        'success': false,
        'message': 'Promotion is not active',
      };
    }

    // Simulate redemption logic
    final redemptionId = 'RED${DateTime.now().millisecondsSinceEpoch}';
    
    // In a real app, this would save to database
    print('Promotion redeemed: $promotionId by user: $userId at station: $stationId');
    
    return {
      'success': true,
      'message': 'Promotion redeemed successfully',
      'redemptionId': redemptionId,
      'discount': promotion['discount'],
      'qrCode': promotion['qrCode'],
    };
  }

  // Validate QR code
  static Map<String, dynamic> validateQRCode(String qrCode) {
    final promotion = _promotions.firstWhere(
      (promotion) => promotion['qrCode'] == qrCode,
      orElse: () => <String, dynamic>{},
    );

    if (promotion.isEmpty) {
      return {
        'valid': false,
        'message': 'Invalid QR code',
      };
    }

    // Check if promotion is still valid
    final now = DateTime.now();
    if (!now.isAfter(promotion['validFrom']) || 
        !now.isBefore(promotion['validUntil'])) {
      return {
        'valid': false,
        'message': 'QR code has expired',
      };
    }

    if (promotion['isActive'] != true) {
      return {
        'valid': false,
        'message': 'QR code is not active',
      };
    }

    return {
      'valid': true,
      'promotion': promotion,
      'message': 'QR code is valid',
    };
  }

  // Get promotion statistics
  static Map<String, dynamic> getPromotionStats() {
    final activePromotions = getActivePromotions();
    final totalPromotions = _promotions.length;
    
    return {
      'total': totalPromotions,
      'active': activePromotions.length,
      'expired': totalPromotions - activePromotions.length,
      'byType': {
        'fuel_discount': getPromotionsByType('fuel_discount').length,
        'combo_offer': getPromotionsByType('combo_offer').length,
        'ev_charging': getPromotionsByType('ev_charging').length,
        'loyalty_bonus': getPromotionsByType('loyalty_bonus').length,
        'shop_discount': getPromotionsByType('shop_discount').length,
        'location_specific': getPromotionsByType('location_specific').length,
      },
    };
  }

  // Generate QR code for promotion
  static String generateQRCode(String promotionId) {
    final promotion = getPromotionById(promotionId);
    if (promotion == null) return '';
    
    // In a real app, this would generate an actual QR code
    return promotion['qrCode'] ?? 'PROMO$promotionId';
  }

  // Get promotion types
  static List<String> getPromotionTypes() {
    return [
      'fuel_discount',
      'combo_offer',
      'ev_charging',
      'loyalty_bonus',
      'shop_discount',
      'location_specific',
    ];
  }

  // Get promotion type display names
  static Map<String, String> getPromotionTypeNames() {
    return {
      'fuel_discount': 'Fuel Discount',
      'combo_offer': 'Combo Offer',
      'ev_charging': 'EV Charging',
      'loyalty_bonus': 'Loyalty Bonus',
      'shop_discount': 'Shop Discount',
      'location_specific': 'Location Specific',
    };
  }

  // Get promotion type icons
  static Map<String, String> getPromotionTypeIcons() {
    return {
      'fuel_discount': '⛽',
      'combo_offer': '🎁',
      'ev_charging': '🔌',
      'loyalty_bonus': '⭐',
      'shop_discount': '🛒',
      'location_specific': '📍',
    };
  }

  // Check if promotion is expiring soon (within 3 days)
  static bool isPromotionExpiringSoon(Map<String, dynamic> promotion) {
    final now = DateTime.now();
    final validUntil = promotion['validUntil'] as DateTime;
    final daysUntilExpiry = validUntil.difference(now).inDays;
    return daysUntilExpiry <= 3 && daysUntilExpiry > 0;
  }

  // Get expiring promotions
  static List<Map<String, dynamic>> getExpiringPromotions() {
    return getActivePromotions().where((promotion) {
      return isPromotionExpiringSoon(promotion);
    }).toList();
  }
}