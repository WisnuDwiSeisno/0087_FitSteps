import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition!, 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lokasi Sekarang')),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16,
              ),
              myLocationEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('current'),
                  position: _currentPosition!,
                  infoWindow: const InfoWindow(title: 'Lokasi Terakhir Anda'),
                ),
              },
              onMapCreated: (controller) => _mapController = controller,
            ),
    );
  }
}
