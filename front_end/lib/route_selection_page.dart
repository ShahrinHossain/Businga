import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'top_up_page.dart';  // Import TopUpPage

class RouteSelectionPage extends StatefulWidget {
  @override
  _RouteSelectionPageState createState() => _RouteSelectionPageState();
}

class _RouteSelectionPageState extends State<RouteSelectionPage> {
  // Google Map Controller
  late GoogleMapController _mapController;

  // Initial Position (Gazipur)
  final LatLng _initialPosition = LatLng(24.0031, 90.4118); // Replace with actual coordinates

  // Markers
  final Set<Marker> _markers = {};

  // Polylines
  final Set<Polyline> _polylines = {};

  // Map Style (Optional)
  String _mapStyle = '''[
    {
      "featureType": "all",
      "elementType": "all",
      "stylers": [
        { "saturation": -80 }
      ]
    }
  ]''';

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _addMarkers();
    _addPolylines();
  }

  // Request Location Permissions
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      if (await Permission.location.request().isGranted) {
        // Permission granted
      } else {
        // Permission denied
        _showPermissionDeniedDialog();
      }
    }
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

  // Add Markers to the Map
  void _addMarkers() {
    setState(() {
      _markers.addAll([
        Marker(
          markerId: MarkerId('start'),
          position: _initialPosition,
          infoWindow: InfoWindow(title: 'Gazipur'),
        ),
        Marker(
          markerId: MarkerId('end'),
          position: LatLng(23.8103, 90.4125), // Example: Dhaka coordinates
          infoWindow: InfoWindow(title: 'Dhaka'),
        ),
      ]);
    });
  }

  // Add Polylines to the Map
  void _addPolylines() {
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route1'),
          points: [
            _initialPosition,
            LatLng(24.0010, 90.4100),
            LatLng(23.8103, 90.4125),
          ],
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  // Map Created Callback
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
      appBar: AppBar(
        title: Text(
          'Route Selection',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
        backgroundColor: Color(0xFF006B5F), // Optional: Same color as the circle
      ),
      body: Stack(
        children: [
          // Circle at the top
          Positioned(
            top: -350, // Adjust as needed to show more or less of the circle
            left: -100,
            right: -100,
            child: Container(
              height: 600, // Height of the circle
              decoration: BoxDecoration(
                color: Color(0xFF006B5F), // Deep sea green color
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.only(
                    top: 60.0,
                    bottom: 40.0,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Destination ...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                // Google Map
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 12.0,
                      ),
                      markers: _markers,
                      polylines: _polylines,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Select route",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Route Options
                _buildRouteOption('R2 | Gazipur - Uttara - Banani - Mohakhali'),
                _buildRouteOption('R7 | Gazipur - Uttara - Mirpur - Mohakhali'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build a route option button
  Widget _buildRouteOption(String route) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // Navigate to TopUpPage when a route is selected
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TopUpPage()),
          );
        },
        child: Text(
          route,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
