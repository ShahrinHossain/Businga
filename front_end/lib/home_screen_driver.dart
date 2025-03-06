import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DriverHomeScreen extends StatefulWidget {
  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  String? _selectedRole;
  TimeOfDay? _startTime;
  int _passengerCount = 0;
  double _totalTransaction = 0.0;
  String _helperName = "Not Assigned";
  Completer<GoogleMapController> _controller = Completer();

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _startWorkingHours() {
    setState(() {
      _startTime = TimeOfDay.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.warning, color: Colors.red),
            onPressed: () {
              // Emergency action
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Account"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Options"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _selectRole("Driver"),
                child: Text("Driver"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedRole == "Driver" ? Colors.blue : Colors.grey,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _selectRole("Helper"),
                child: Text("Helper"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedRole == "Helper" ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _startWorkingHours,
            child: Text("Start Working Hours"),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.7749, -122.4194),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                Text("Current Passenger Count: $_passengerCount"),
                Text("Total Transaction: \$_${_totalTransaction.toStringAsFixed(2)}"),
                Text("Helper: $_helperName"),
                Text("Working Since: ${_startTime != null ? _startTime!.format(context) : "Not Started"}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
