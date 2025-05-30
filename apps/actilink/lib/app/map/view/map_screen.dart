import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  bool _isMapCreated = false;
  bool _hasError = false;
  String _errorMessage = '';

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.2297, 21.0122), // Warsaw coordinates
    zoom: 13.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venues Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            compassEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              log('Map creation started');
              try {
                setState(() {
                  _mapController = controller;
                  _isMapCreated = true;
                  _hasError = false;
                });
                log('Map created successfully');
              } catch (e) {
                log('Error creating map: $e');
                setState(() {
                  _hasError = true;
                  _errorMessage = e.toString();
                });
              }
            },
          ),
          if (!_isMapCreated && !_hasError)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_hasError)
            Center(
              child: Text('Error loading map: $_errorMessage'),
            ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}