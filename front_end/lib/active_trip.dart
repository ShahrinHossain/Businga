import 'dart:convert';
import 'package:businga1/top_up_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globalVariables.dart';

class ActiveTrip extends StatefulWidget {
  @override
  _ActiveTripState createState() => _ActiveTripState();
}

class _ActiveTripState extends State<ActiveTrip> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  LatLng? sourceLocation;
  LatLng? destinationLocation;
  LatLng? nearestSourceStoppage;
  LatLng? nearestDestStoppage;
  String? nearestSrcName;
  String? nearestDestName;

  LatLng? currentLocation;
  Map<String, dynamic>? tripInfo; // To store trip information

  final String apiKey = 'AIzaSyB9C6viTxdaZbqrwtU8KqRxyIYTT1AmXYA'; // Replace with your API Key

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _fetchTripInfo();
  }

  // Add this method to fetch trip information
  Future<void> _fetchTripInfo() async {
    String? token = await getAuthToken();
    if (token == null) {
      print("User not logged in");
      return;
    }

    String baseUrl = getIp();
    String apiUrl = "$baseUrl/users/get-current-trip/";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tripInfo = data;
        });
      } else {
        print("Failed to fetch trip info: ${response.body}");
      }
    } catch (e) {
      print("Error fetching trip info: $e");
    }
  }


  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Retrieve stored token
  }

  Future<LatLng?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return null;
    }

    // Request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return null;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }


  Future<Map<String, dynamic>?> _findNearestStoppage(double latitude, double longitude) async {
    String? token = await getAuthToken();
    if (token == null) {
      print("User not logged in");
      return null;
    }

    String baseUrl = getIp();
    String apiUrl = "$baseUrl/users/get-nearest-stoppage/";

    try {
      final response = await http.get(
        Uri.parse("$apiUrl?latitude=$latitude&longitude=$longitude"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final stoppage = data["stoppage"];

        print("Nearest Stoppage: ${stoppage['name']} at (${stoppage['latitude']}, ${stoppage['longitude']})");

        LatLng stoppageLocation = LatLng(stoppage['latitude'], stoppage['longitude']);

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(stoppage['name']),
              position: stoppageLocation,
              infoWindow: InfoWindow(title: stoppage['name']),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            ),
          );
        });

        // Return both LatLng and stoppage name
        return {
          "location": stoppageLocation,
          "name": stoppage['name'],
        };
      } else {
        print("Failed to get nearest stoppage: ${response.body}");
      }
    } catch (e) {
      print("Error calling API: $e");
    }
    return null;
  }


  Future<void> _loadLocations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    double? srcLat = prefs.getDouble('src_lat');
    double? srcLng = prefs.getDouble('src_lng');
    double? destLat = prefs.getDouble('dest_lat');
    double? destLng = prefs.getDouble('dest_lng');

    currentLocation = await _determinePosition(); // Fetch current location

    if (currentLocation != null) {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId("currentLocation"),
          position: currentLocation!,
          infoWindow: InfoWindow(title: "Your Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      });
    }

    if (srcLat != null && srcLng != null && destLat != null && destLng != null) {
      setState(() {
        sourceLocation = LatLng(srcLat, srcLng);
        destinationLocation = LatLng(destLat, destLng);
      });

      // Fetch nearest source stoppage
      Map<String, dynamic>? sourceStoppage = await _findNearestStoppage(srcLat, srcLng);
      if (sourceStoppage != null) {
        nearestSourceStoppage = sourceStoppage["location"];
        nearestSrcName = sourceStoppage["name"];
      }

      // Fetch nearest destination stoppage
      Map<String, dynamic>? destStoppage = await _findNearestStoppage(destLat, destLng);
      if (destStoppage != null) {
        nearestDestStoppage = destStoppage["location"];
        nearestDestName = destStoppage["name"];
      }

      // Calculate fare
      if (currentLocation != null && nearestSourceStoppage != null) {
        double? distance = await _calculateRouteDistance(currentLocation!, nearestSourceStoppage!);
        if (distance != null) {
          double fare = (distance * 2.45).clamp(10, double.infinity); // Ensure fare is at least 10
          setState(() {
            tripInfo = {"fare": fare.toStringAsFixed(2)}; // Store fare in tripInfo
          });
        }
      }

      if (nearestSourceStoppage != null && sourceLocation != null) {
        await _getPolyline(sourceLocation!, nearestSourceStoppage!, "walk_source", "WALK");
      }

      if (nearestDestStoppage != null && destinationLocation != null) {
        await _getPolyline(nearestDestStoppage!, destinationLocation!, "walk_dest", "WALK");
      }

      if (nearestSourceStoppage != null && nearestDestStoppage != null) {
        await _getPolyline(nearestSourceStoppage!, nearestDestStoppage!, "bus_route", "DRIVE");
      }

      _addMarkers();
    } else {
      print("Locations not found in SharedPreferences.");
    }
  }


  void _addMarkers() {
    if (sourceLocation == null || destinationLocation == null ||
        nearestSourceStoppage == null || nearestDestStoppage == null) return;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("source"),
        position: sourceLocation!,
        infoWindow: InfoWindow(title: "Source"),
      ));

      _markers.add(Marker(
        markerId: MarkerId("nearestSource"),
        position: nearestSourceStoppage!,
        infoWindow: InfoWindow(title: "Nearest Source Stoppage"),
      ));

      _markers.add(Marker(
        markerId: MarkerId("nearestDestination"),
        position: nearestDestStoppage!,
        infoWindow: InfoWindow(title: "Nearest Destination Stoppage"),
      ));

      _markers.add(Marker(
        markerId: MarkerId("destination"),
        position: destinationLocation!,
        infoWindow: InfoWindow(title: "Destination"),
      ));
    });
  }

  Future<void> _getPolyline(LatLng start, LatLng end, String id, String travelMode) async {
    const String url = "https://routes.googleapis.com/directions/v2:computeRoutes";

    final Map<String, dynamic> requestBody = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": start.latitude,
            "longitude": start.longitude,
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": end.latitude,
            "longitude": end.longitude,
          }
        }
      },
      "travelMode": travelMode, // "DRIVE" or "WALK"
      "computeAlternativeRoutes": false,
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
        "X-Goog-FieldMask": "routes.polyline.encodedPolyline"
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data["routes"].isNotEmpty) {
        String encodedPolyline = data["routes"][0]["polyline"]["encodedPolyline"];
        _decodePolyline(encodedPolyline, id);
      }
    } else {
      print("Failed to load route: ${response.statusCode}");
    }
  }

// Modify _decodePolyline() to handle multiple polylines
  void _decodePolyline(String encodedPolyline, String polylineId) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);
    List<LatLng> polylineSegment = [];

    if (result.isNotEmpty) {
      for (var point in result) {
        polylineSegment.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId(polylineId),
          color: polylineId.contains("walk") ? Colors.green : Colors.blue,
          width: 5,
          points: polylineSegment,
        ));
      });
    }
  }

  Future<double?> _calculateRouteDistance(LatLng start, LatLng end) async {
    const String url = "https://routes.googleapis.com/directions/v2:computeRoutes";

    final Map<String, dynamic> requestBody = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": start.latitude,
            "longitude": start.longitude,
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": end.latitude,
            "longitude": end.longitude,
          }
        }
      },
      "travelMode": "DRIVE", // Use "DRIVE" for route distance
      "computeAlternativeRoutes": false,
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
        "X-Goog-FieldMask": "routes.distanceMeters"
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data["routes"].isNotEmpty) {
        int distanceMeters = data["routes"][0]["distanceMeters"];
        double distanceKm = distanceMeters / 1000.0; // Convert meters to kilometers
        return distanceKm;
      }
    } else {
      print("Failed to calculate route distance: ${response.statusCode}");
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route View"),
        backgroundColor: Colors.green,
        elevation: 2,
      ),
      body: Stack(
        children: [
          // Google Map
          sourceLocation == null || destinationLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: currentLocation ?? nearestSourceStoppage!,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),

          // Trip Info Card (Overlay)
          if (true)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From: $nearestSrcName",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "To: $nearestDestName",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Fare: ${tripInfo!['fare']} BDT",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Start Journey Button (Overlay)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopUpPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "End Journey",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
