import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Route View")),
      body: Center(
        child: FutureBuilder<void>(
          future: _loadCoordinates(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error loading coordinates");
            } else {
              return Text("Route from Source to Destination");
            }
          },
        ),
      ),
    );
  }

  Future<void> _loadCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double srcLat = prefs.getDouble('src_lat') ?? 0.0;
    double srcLng = prefs.getDouble('src_lng') ?? 0.0;
    double destLat = prefs.getDouble('dest_lat') ?? 0.0;
    double destLng = prefs.getDouble('dest_lng') ?? 0.0;

    print("Source Coordinates: ($srcLat, $srcLng)");
    print("Destination Coordinates: ($destLat, $destLng)");

    // You can use these coordinates to show a route or perform additional operations
  }
}
