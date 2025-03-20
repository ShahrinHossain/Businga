import 'dart:convert';
import 'package:businga1/top_up_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globalVariables.dart';

class RouteView extends StatefulWidget {
  @override
  _RouteViewState createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  LatLng? sourceLocation;
  LatLng? destinationLocation;
  LatLng? nearestSourceStoppage;
  LatLng? nearestDestStoppage;

  final String apiKey = 'AIzaSyB9C6viTxdaZbqrwtU8KqRxyIYTT1AmXYA'; // Replace with your API Key

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Retrieve stored token
  }

  Future<LatLng?> _findNearestStoppage(double latitude, double longitude) async {
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

        return stoppageLocation;
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

    if (srcLat != null && srcLng != null && destLat != null && destLng != null) {
      setState(() {
        sourceLocation = LatLng(srcLat, srcLng);
        destinationLocation = LatLng(destLat, destLng);
      });

      nearestSourceStoppage = await _findNearestStoppage(srcLat, srcLng);
      nearestDestStoppage = await _findNearestStoppage(destLat, destLng);

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

  // Future<void> _getWalkingPolyline(LatLng start, LatLng end, String id) async {
  //   final String url = "https://routes.googleapis.com/directions/v2:computeRoutes";
  //
  //   final Map<String, dynamic> requestBody = {
  //     "origin": {
  //       "location": {
  //         "latLng": {
  //           "latitude": start.latitude,
  //           "longitude": start.longitude,
  //         }
  //       }
  //     },
  //     "destination": {
  //       "location": {
  //         "latLng": {
  //           "latitude": end.latitude,
  //           "longitude": end.longitude,
  //         }
  //       }
  //     },
  //     "travelMode": "WALK",
  //     "computeAlternativeRoutes": false,
  //     "routeModifiers": {
  //     },
  //     "languageCode": "en-US",
  //     "units": "IMPERIAL"
  //   };
  //
  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "X-Goog-Api-Key": apiKey,
  //       "X-Goog-FieldMask": "routes.polyline.encodedPolyline"
  //     },
  //     body: jsonEncode(requestBody),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = jsonDecode(response.body);
  //     if (data["routes"].isNotEmpty) {
  //       String encodedPolyline = data["routes"][0]["polyline"]["encodedPolyline"];
  //       _decodePolyline(encodedPolyline);
  //     }
  //   } else {
  //     print("Failed to load walking route: ${response.statusCode}");
  //   }
  // }

  // void _decodePolyline(String encodedPolyline) {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);
  //
  //   if (result.isNotEmpty) {
  //     setState(() {
  //       polylineCoordinates.clear();
  //       for (var point in result) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       }
  //       _polylines.add(Polyline(
  //         polylineId: PolylineId("route"),
  //         color: Colors.blue,
  //         width: 5,
  //         points: polylineCoordinates,
  //       ));
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route View"),
        backgroundColor: Colors.green, // Customize as needed
        elevation: 2,
      ),
      body: Stack(
        children: [
          // Google Map
          sourceLocation == null || destinationLocation == null
              ? Center(child: CircularProgressIndicator()) // Loader
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: nearestSourceStoppage!,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
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
                backgroundColor: Colors.green, // Customize color
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Start Journey",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
