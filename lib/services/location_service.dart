import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Position? _currentPosition;
  static String? _currentAddress;

  static Position? get currentPosition => _currentPosition;
  static String? get currentAddress => _currentAddress;

  /// Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Request location permission
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Get current location
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location permission is granted
      if (!await isLocationPermissionGranted()) {
        final granted = await requestLocationPermission();
        if (!granted) {
          throw Exception('Location permission denied');
        }
      }

      // Check if location services are enabled
      if (!await isLocationServiceEnabled()) {
        throw Exception('Location services are disabled');
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Get address from coordinates
      await _getAddressFromPosition(_currentPosition!);

      return _currentPosition;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// Get address from position
  static Future<void> _getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentAddress = '${place.locality}, ${place.administrativeArea}';
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Get nearby stations within a radius
  static List<Map<String, dynamic>> getNearbyStations(
    List<Map<String, dynamic>> stations,
    double radiusKm,
  ) {
    if (_currentPosition == null) return stations;

    return stations.where((station) {
      final stationLat = station['latitude'] as double?;
      final stationLon = station['longitude'] as double?;

      if (stationLat == null || stationLon == null) return false;

      final distance = calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        stationLat,
        stationLon,
      );

      return distance <= radiusKm;
    }).toList();
  }

  /// Check if user is near a specific location
  static bool isNearLocation(
    double targetLat,
    double targetLon,
    double radiusKm,
  ) {
    if (_currentPosition == null) return false;

    final distance = calculateDistance(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      targetLat,
      targetLon,
    );

    return distance <= radiusKm;
  }

  /// Get location-based promotions
  static List<Map<String, dynamic>> getLocationBasedPromotions(
    List<Map<String, dynamic>> promotions,
  ) {
    if (_currentPosition == null) return [];

    return promotions.where((promotion) {
      final targetLat = promotion['latitude'] as double?;
      final targetLon = promotion['longitude'] as double?;
      final radius =
          promotion['radius'] as double? ?? 5.0; // Default 5km radius

      if (targetLat == null || targetLon == null) return false;

      return isNearLocation(targetLat, targetLon, radius);
    }).toList();
  }

  /// Initialize location service
  static Future<void> initialize() async {
    try {
      await getCurrentLocation();
    } catch (e) {
      print('Location service initialization failed: $e');
    }
  }

  /// Reset location data
  static void reset() {
    _currentPosition = null;
    _currentAddress = null;
  }
}
