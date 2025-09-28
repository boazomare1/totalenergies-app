import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationMapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> stations;
  final Function(Map<String, dynamic>) onStationSelected;
  final LatLng? userLocation;

  const StationMapWidget({
    super.key,
    required this.stations,
    required this.onStationSelected,
    this.userLocation,
  });

  @override
  State<StationMapWidget> createState() => _StationMapWidgetState();
}

class _StationMapWidgetState extends State<StationMapWidget> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  @override
  void didUpdateWidget(StationMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stations != widget.stations) {
      _createMarkers();
    }
  }

  void _createMarkers() {
    _markers.clear();
    
    for (int i = 0; i < widget.stations.length; i++) {
      final station = widget.stations[i];
      final position = LatLng(
        station['latitude'] ?? 0.0,
        station['longitude'] ?? 0.0,
      );
      
      _markers.add(
        Marker(
          markerId: MarkerId('station_$i'),
          position: position,
          infoWindow: InfoWindow(
            title: station['name'] ?? 'Station',
            snippet: station['address'] ?? '',
          ),
          onTap: () {
            widget.onStationSelected(station);
          },
        ),
      );
    }

    // Add user location marker if available
    if (widget.userLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: widget.userLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });
  }

  void _centerOnUserLocation() {
    if (_mapController != null && widget.userLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(widget.userLocation!, 15.0),
      );
    }
  }

  void _centerOnStation(Map<String, dynamic> station) {
    if (_mapController != null) {
      final position = LatLng(
        station['latitude'] ?? 0.0,
        station['longitude'] ?? 0.0,
      );
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(position, 16.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stations.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No stations found',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.userLocation ?? LatLng(
                  widget.stations.first['latitude'] ?? 0.0,
                  widget.stations.first['longitude'] ?? 0.0,
                ),
                zoom: 12.0,
              ),
              markers: _markers,
              myLocationEnabled: widget.userLocation != null,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    onPressed: _centerOnUserLocation,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.my_location,
                      color: widget.userLocation != null 
                          ? const Color(0xFFE60012) 
                          : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    onPressed: () {
                      if (widget.stations.isNotEmpty) {
                        _centerOnStation(widget.stations.first);
                      }
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.center_focus_strong,
                      color: Color(0xFFE60012),
                    ),
                  ),
                ],
              ),
            ),
            if (!_isMapReady)
              Container(
                color: Colors.grey[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: const Color(0xFFE60012),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading map...',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
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
}