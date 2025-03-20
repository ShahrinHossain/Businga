import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'globalVariables.dart';

var baseUrl = getIp();
const deepSeaGreen = Color(0xFF00756A);

class DriverTableScreen extends StatefulWidget {
  final Function()? onTap;
  final int? companyId;
  const DriverTableScreen({super.key, required this.onTap, this.companyId});

  @override
  State<DriverTableScreen> createState() => _DriverTableScreenState();
}

class _DriverTableScreenState extends State<DriverTableScreen> {
  List<dynamic> drivers = [];  // List to store driver data

  @override
  void initState() {
    super.initState();
    fetchDrivers();  // Fetch drivers when the page loads
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Get the stored token
  }

  Future<void> fetchDrivers() async {
    String? token = await getAuthToken();
    if (token == null) {
      // Handle the case where the token is not available
      print('User is not logged in');
      return;
    }

    final url = Uri.parse('$baseUrl/users/drivers/${widget.companyId}');  // Call the API

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Add the Authorization header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          drivers = data;  // Update the list of drivers
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to load drivers"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred while fetching drivers"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              'Driver List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: drivers.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];
            return GestureDetector(
              onTap: () {
                // Show the dialog with the additional details when tapped
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.greenAccent, // Set the background to the green accent color
                      title: Text(
                        'Driver Details',
                        style: TextStyle(color: Colors.black), // Black title text
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'License No: ${driver['license_no']}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Text(
                            'Contact: ${driver['contact_no'] ?? 'N/A'}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Text(
                            'Location: ${driver['location'] ?? 'N/A'}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();  // Close the dialog
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.black), // Black button text
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),  // Increase margin for larger boxes
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFF006B5F),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),  // Add padding to increase the box size
                  title: Text(
                    'Name: ${driver['name']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,  // Increased font size for the title
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${driver['user_id']}',
                        style: TextStyle(
                          color: Colors.teal[800],
                          fontSize: 16,  // Increased font size for the subtitle
                        ),
                      ),
                      // Display duty status with checkboxes
                      Row(
                        children: [
                          // "On duty" checkbox
                          GestureDetector(
                            onTap: () {
                              // You can add functionality here if needed when the checkbox is tapped
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: driver['on_duty'],
                                  activeColor: Colors.green, // Green checkbox color
                                  onChanged: (bool? value) {
                                    // Handle checkbox state change if needed
                                  },
                                ),
                                Text(
                                  'On Duty',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 40), // Increased space between "On duty" and "Off duty"
                          // "Off duty" checkbox
                          GestureDetector(
                            onTap: () {
                              // You can add functionality here if needed when the checkbox is tapped
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: !driver['on_duty'],
                                  activeColor: Colors.red, // Green checkbox color
                                  // If not on duty, it's off duty
                                  onChanged: (bool? value) {
                                    // Handle checkbox state change if needed
                                  },
                                ),
                                Text(
                                  'Off Duty',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {},
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
        selectedItemColor: Colors.teal[700],
      ),
    );
  }
}
