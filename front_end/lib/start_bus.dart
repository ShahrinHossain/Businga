import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'globalVariables.dart';
import 'home_screen_driver.dart';
import 'login_screen.dart';

class StartBus extends StatefulWidget {
  final int userId;

  StartBus({required this.userId});

  @override
  _StartBusState createState() => _StartBusState();
}

class _StartBusState extends State<StartBus> {
  late Map<String, dynamic> driverData = {};
  List<dynamic> dont_buses = [];
  List<dynamic> buses = [];
  int? selectedBusId;
  int? companyId;

  @override
  void initState() {
    super.initState();
    _fetchDriverData();
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _fetchDriverData() async {
    String? token = await getAuthToken();
    if (token == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${getIp()}/users/current-driver/${widget.userId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          driverData = data;
          companyId = data['company']; // Store companyId
        });

        if (data.containsKey('company')) {
          _fetchDontBusList(data['company']);
          _fetchBusList(data['company']);
          companyId = data['company'];
        }
      } else {
        print('Failed to fetch driver data: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _fetchDontBusList(int companyId) async {
    String? token = await getAuthToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('${getIp()}/users/dont-choose-bus/$companyId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dontbusData = json.decode(response.body);
        setState(() {
          dont_buses = dontbusData;
        });
      } else {
        print('Failed to fetch dont_buses: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _fetchBusList(int companyId) async {
    String? token = await getAuthToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('${getIp()}/users/buses/$companyId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final busData = json.decode(response.body);
        setState(() {
          buses = busData is List ? busData : [];
        });
      } else {
        print('Failed to fetch buses: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  // New function to start the bus route
  Future<void> _startBusRoute() async {
    if (selectedBusId == null || companyId == null) {
      // Show an error if bus or company ID is not selected
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a bus and ensure valid company ID$selectedBusId$companyId'),
        backgroundColor: Colors.red,
      ));
      print('Selected Bus ID: $selectedBusId');
      print('Company ID: $companyId');
      return;
    }

    String? token = await getAuthToken();
    if (token == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return;
    }

    final requestData = {
      'bus_id': selectedBusId,
      'driver_id': widget.userId,
      'company_id': companyId,
    };

    print('Request Data: $requestData'); // Debugging print statement

    try {
      final response = await http.post(
        Uri.parse('${getIp()}/users/add-on-route/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 201) {
        // Successfully started the bus route
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Bus Started!'),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DriverHomeScreen(), // Replace with your DriverHomeScreen widget
          ),
        );
      } else {
        // Handle failure response
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to start bus route'),
          backgroundColor: Colors.red,
        ));
        print('API Response: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred while starting the bus route'),
        backgroundColor: Colors.red,
      ));
    }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[800],
      body: driverData.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.teal[800],
        ),
      )
          : buses.isEmpty
          ? Center(
          child: Text("No buses available", style: TextStyle(color: Colors.white)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 130),
            Center(
              child: Text(
                "Select a vehicle for driving",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Scrollbar(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: buses.length,
                    itemBuilder: (context, index) {
                      final bus = buses[index];
                      bool isOnRoute = dont_buses.any((dontBus) => dontBus['id'] == bus['id']);

                      return GestureDetector(
                        onTap: isOnRoute
                            ? null
                            : () {
                          setState(() {
                            selectedBusId = bus['id'];
                          });
                        },
                        child: Card(
                          color: isOnRoute
                              ? Colors.grey
                              : (selectedBusId == bus['id'] ? Colors.white : Colors.green[100]),
                          margin: EdgeInsets.symmetric(vertical: 6.0),
                          child: ListTile(
                            title: Text(
                              "Bus: ${bus['id'] ?? 'N/A'}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Registration No: ${bus['registration_no'] ?? 'N/A'}"),
                                Text("Location: ${bus['location'].toString()}"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: selectedBusId != null ? _startBusRoute : null,
                child: Text("Start"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
