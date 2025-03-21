import 'dart:convert';
import 'dart:math';
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

  int? fromID, toID;

  final String apiKey = 'AIzaSyB9C6viTxdaZbqrwtU8KqRxyIYTT1AmXYA'; // Replace with your API Key

  // Mock trip data (replace with actual data from your API)
  final Map<String, dynamic> trip = {
    'from_stoppage': {'name': 'Gazipur Chourasta'},
    'to_stoppage': {'name': 'Azimpur'},
    'arrival_time': '2023-10-15T10:00:00Z',
    'timestamp': '2023-10-15T09:00:00Z',
    'distance': '12.5',
    'fare': '45.00',
  };

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Retrieve stored token
  }

  Future<void> _checkRouteAndDrawPolyline(LatLng fromStoppage, LatLng toStoppage) async {
    String? token = await getAuthToken();
    if (token == null) {
      print("User not logged in");
      return;
    }

    String baseUrl = getIp();
    String apiUrl = "$baseUrl/users/check-route/";

    try {
      final response = await http.get(
        Uri.parse("$apiUrl?from_stoppage_id=$fromID&to_stoppage_id=$toID"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["message"] == "Valid route found.") {
          final route = data["route"];
          final coordinatesList = route["coordinates_list"];

          // Extract the first and last stoppage coordinates
          LatLng firstStoppage = LatLng(
            coordinatesList.first['latitude'],
            coordinatesList.first['longitude'],
          );
          LatLng lastStoppage = LatLng(
            coordinatesList.last['latitude'],
            coordinatesList.last['longitude'],
          );

          // Make an API call to get the transit route between first and last stoppage
          await _getPolyline(firstStoppage, lastStoppage, "full_route", "TRANSIT");
        } else {
          print("No valid route found.");
        }
      } else {
        print("Failed to check route: ${response.body}");
      }
    } catch (e) {
      print("Error calling API: $e");
    }
  }

  Future<Map<String, dynamic>> _findNearestStoppage(double latitude, double longitude) async {
    String? token = await getAuthToken();
    if (token == null) {
      print("User not logged in");
      throw Exception("User not logged in"); // Throw an exception or return an empty map
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

        return stoppage; // Return the stoppage data
      } else {
        print("Failed to get nearest stoppage: ${response.body}");
        throw Exception("Failed to get nearest stoppage: ${response.body}");
      }
    } catch (e) {
      print("Error calling API: $e");
      throw Exception("Error calling API: $e"); // Rethrow the exception
    }
  }

  Future<void> _loadLocations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    double? srcLat = prefs.getDouble('src_lat');
    double? srcLng = prefs.getDouble('src_lng');
    double? destLat = prefs.getDouble('dest_lat');
    double? destLng = prefs.getDouble('dest_lng');

    // Fetch stoppage names from SharedPreferences
    String? srcStoppageName = prefs.getString('src_stoppage_name');
    String? destStoppageName = prefs.getString('dest_stoppage_name');

    if (srcLat != null && srcLng != null && destLat != null && destLng != null) {
      setState(() {
        sourceLocation = LatLng(srcLat, srcLng);
        destinationLocation = LatLng(destLat, destLng);

        // Update trip data with stoppage names from SharedPreferences
        trip['from_stoppage']['name'] = srcStoppageName ?? 'Unknown Source';
        trip['to_stoppage']['name'] = destStoppageName ?? 'Unknown Destination';
      });

      var srcObj = await _findNearestStoppage(srcLat, srcLng);
      nearestSourceStoppage = LatLng(srcObj['latitude'], srcObj['longitude']);
      var destObj = await _findNearestStoppage(destLat, destLng);
      nearestDestStoppage = LatLng(destObj['latitude'], destObj['longitude']);

      fromID = srcObj['id'];
      toID = destObj['id'];

      // Get current location
      LatLng? currentLocation = await _getCurrentLocation();
      if (currentLocation != null) {
        // Calculate distance and time from current location to nearest source
        Map<String, dynamic> srcDistanceTime = await _calculateDistanceAndTime(currentLocation, nearestSourceStoppage!);
        // Calculate distance and time from current location to nearest destination
        Map<String, dynamic> destDistanceTime = await _calculateDistanceAndTime(nearestSourceStoppage!, nearestDestStoppage!);

        setState(() {
          trip['distance'] = destDistanceTime["distance"]; // Update distance
          trip['fare'] = max(double.parse(srcDistanceTime["distance"]) * 2.45, 10).toStringAsFixed(2); // Calculate fare
          trip['arrival_time'] = destDistanceTime["duration"]; // Update travel time
        });
      }

      if (nearestSourceStoppage != null && nearestDestStoppage != null) {
        await _checkRouteAndDrawPolyline(nearestSourceStoppage!, nearestDestStoppage!);
      }

      if (nearestSourceStoppage != null && sourceLocation != null) {
        await _getPolyline(sourceLocation!, nearestSourceStoppage!, "walk_source", "WALK");
      }

      if (nearestDestStoppage != null && destinationLocation != null) {
        await _getPolyline(nearestDestStoppage!, destinationLocation!, "walk_dest", "WALK");
      }

      if (nearestSourceStoppage != null && nearestDestStoppage != null) {
        await _getPolyline(nearestSourceStoppage!, nearestDestStoppage!, "bus_route", "TRANSIT");
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
        markerId: const MarkerId("nearestSource"),
        position: nearestSourceStoppage!,
        infoWindow: const InfoWindow(title: "Nearest Source Stoppage"),
      ));

      _markers.add(Marker(
        markerId: const MarkerId("nearestDestination"),
        position: nearestDestStoppage!,
        infoWindow: const InfoWindow(title: "Nearest Destination Stoppage"),
      ));

      _markers.add(Marker(
        markerId: const MarkerId("destination"),
        position: destinationLocation!,
        infoWindow: const InfoWindow(title: "Destination"),
      ));
    });
  }

  Future<void> _getPolyline(LatLng start, LatLng end, String id, String travelMode) async {
    final String url = "https://routes.googleapis.com/directions/v2:computeRoutes";

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

  Future<Map<String, dynamic>> _calculateDistanceAndTime(LatLng origin, LatLng destination) async {
    final String url = "https://routes.googleapis.com/directions/v2:computeRoutes";

    final Map<String, dynamic> requestBody = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": origin.latitude,
            "longitude": origin.longitude,
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": destination.latitude,
            "longitude": destination.longitude,
          }
        }
      },
      "travelMode": "DRIVE", // Use TRANSIT mode
      "computeAlternativeRoutes": false,
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
        "X-Goog-FieldMask": "routes.distanceMeters,routes.duration"
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data["routes"].isNotEmpty) {
        int distanceMeters = data["routes"][0]["distanceMeters"];
        String duration = data["routes"][0]["duration"];

        double distanceKm = distanceMeters / 1000.0; // Convert meters to kilometers
        return {
          "distance": distanceKm.toStringAsFixed(2),
          "duration": duration,
        };
      }
    } else {
      print("Failed to calculate distance and time: ${response.statusCode}");
    }
    return {"distance": "N/A", "duration": "N/A"};
  }

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
          color: polylineId.contains("walk") ? Colors.green : (polylineId.contains("bus") ? Colors.blue : Colors.cyan),
          width: 5,
          points: polylineSegment,
        ));
      });
    }
  }

  Future<LatLng?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return null;
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  // Helper function to format date-time
  String formatDateTime(String dateTime) {
    // Add your date-time formatting logic here
    return dateTime; // Replace with formatted date-time
  }

  String _formatDuration(String durationInSeconds) {
    try {
      // Remove any non-numeric characters (like 's') from the string
      String numericString = durationInSeconds.replaceAll(RegExp(r'[^0-9]'), '');

      int seconds = int.parse(numericString);
      Duration duration = Duration(seconds: seconds);

      String hours = duration.inHours.toString().padLeft(2, '0');
      String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');

      return '$hours h $minutes m'; // Format: "02 h 30 m"
    } catch (e) {
      return 'N/A'; // Handle invalid duration
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Trip"), // Changed title
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
              target: nearestSourceStoppage!,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),

          // Trip Info Card (Overlay)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Trip Stoppage Names
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            trip['from_stoppage']['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "To",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            trip['to_stoppage']['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Animated Progress Bar
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          width: MediaQuery.of(context).size.width * 0.5, // Adjust based on progress
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.orangeAccent, Colors.redAccent],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Remaining Time and Distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time Left",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            _formatDuration(trip['arrival_time']),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Distance",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${trip['distance']} km',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Fare and Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Fare",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            '${trip['fare']} BDT',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TopUpPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "End Journey",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // End Journey Button (Overlay)
          // Positioned(
          //   bottom: 20,
          //   left: 20,
          //   right: 20,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => TopUpPage()),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.green,
          //       padding: const EdgeInsets.symmetric(vertical: 15),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     child: const Text(
          //       "End Journey",
          //       style: TextStyle(fontSize: 18, color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}