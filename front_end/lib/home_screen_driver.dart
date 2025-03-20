import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart'; // For permissions
import 'package:geolocator/geolocator.dart';

import 'emergency_button.dart'; // For location tracking

class DriverHomeScreen extends StatefulWidget {
  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  String _nextStoppage = "Motijheel";
  int _passengerCount = 0;
  double _totalTransaction = 0.0;
  String _helperName = "Not Assigned";
  Completer<GoogleMapController> _controller = Completer();
  int _selectedIndex = 0; // Track the selected index

  // Location variables
  late LatLng _currentLocation; // Variable to store current location
  late GoogleMapController _mapController;
  Set<Marker> _markers = {}; // Markers for map

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Request Location Permissions
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      if (await Permission.location.request().isGranted) {
        // Permission granted, get the location
        _getCurrentLocation();
      } else {
        // Permission denied, show a dialog
        _showPermissionDeniedDialog();
      }
    } else {
      // Permission already granted, get the location
      _getCurrentLocation();
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _addMarker();
    });
  }

  // Add current location marker
  void _addMarker() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('current_location'),
        position: _currentLocation,
        infoWindow: InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
  }

  // Show Permission Denied Dialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission'),
        content: Text('Location permission is required to show your current location on the map.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Map Created Callback
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Move camera to the current location
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation, 15.0));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal[800]),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Bussinga',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            Text(
              'Driver Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -200,
            left: -100,
            right: -100,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Color(0xFF006B5F),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 370,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF006B5F),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(37.7749, -122.4194), // Default position before location
                      zoom: 10.0,
                    ),
                    onMapCreated: _onMapCreated,
                    markers: _markers, // Display markers
                    myLocationEnabled: true, // Enable user's location
                    myLocationButtonEnabled: true, // Show the location button
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildInfoCard("Passenger Count: $_passengerCount"),
                      _buildInfoCard("Total Transaction: \$_${_totalTransaction.toStringAsFixed(2)}"),
                      _buildInfoCard("Assistant Name: $_helperName"),
                      _buildInfoCard("Next Stoppage: $_nextStoppage"), // New info card
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Emergency Button Positioned at top right corner
          Positioned(
            top: 4, // Position the button from top
            left: 20, // Position the button from the left
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmergencyButton(
                      busOwnerPhoneNumber: "+8801793597139", // Replace with actual bus owner's phone number
                      policeStationPhoneNumber: "+098102102", // Replace with actual police station's phone number
                    ),
                  ),
                );
              },
              backgroundColor: Colors.red, // Red button color
              child: Icon(Icons.warning, size: 30, color: Colors.white), // Emergency icon
            ),
          )

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Function to build info cards
  // Function to build info cards
  Widget _buildInfoCard(String content) {
    // Split content to separate the label and value
    List<String> parts = content.split(':');
    String label = parts[0].trim();
    String value = parts.length > 1 ? parts[1].trim() : '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFF006B5F),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800], // Optional: Customize label color
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Optional: Customize value color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
