import 'package:businga1/driver_table_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'add_bus_screen.dart';
import 'bus_table_screen.dart';
import 'globalVariables.dart';
import 'add_driver_screen.dart';

var baseUrl = getIp(); // Dynamically fetch the base URL

class BusOwnerHomeScreen extends StatefulWidget {
  @override
  _BusOwnerHomeScreenState createState() => _BusOwnerHomeScreenState();
}

class _BusOwnerHomeScreenState extends State<BusOwnerHomeScreen> {
  int _selectedIndex = 0;
  String? _balance; // Stores the fetched balance
  String? _companyName; // Stores the company name
  bool _isLoading = true;// Tracks if the data is being loaded
  int? _companyId;

  String? _username; // Stores the current user's username

  // Function to get the stored JWT token from SharedPreferences
  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Get the stored token
  }

  // Function to fetch user data using the token
  Future<void> getUserData() async {
    String? token = await getAuthToken();
    if (token == null) {
      // Handle the case where the token is not available
      print('User is not logged in');
      return;
    }

    try {
      // Fetch user data from the "current-owner" API
      final response = await http.get(
        Uri.parse('$baseUrl/users/current-owner/'),
        headers: {
          'Authorization': 'Bearer $token', // Add token in Authorization header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Handle success
        final userData = json.decode(response.body);
        setState(() {
          // Extract values from the response and assign them to the variables
          _companyName = userData['name'] ?? 'N/A'; // Using 'name' for company name
          _balance = userData['income']?.toString() ?? 'N/A'; // Using 'income' for balance
          _companyId = userData['id'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _balance = '100.00';
          _companyName = 'Unknown';
          _isLoading = false;
        });
        // Handle failure (e.g., unauthorized)
        print('Failed to fetch user data: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _balance = '100.00';
        _companyName = 'Unknown';
        _isLoading = false;
      });
      print('An error occurred: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    getUserData(); // Fetch user data when screen loads
  }

  // Method to handle bottom navigation taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // This keeps the layout fixed when the keyboard appears
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
              'Owner Dashboard',
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
          // Circle at the bottom
          Positioned(
            bottom: -200, // Adjust to position the circle correctly
            left: -100,
            right: -100,
            child: Container(
              height: 400, // Height of the circle
              decoration: BoxDecoration(
                color: Color(0xFF006B5F), // Deep sea green color
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // The scrolling content goes here
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      // Company Info - Dynamic content here
                      _buildInfoCard('Company', _isLoading ? 'Loading...' : (_companyName ?? 'Unknown'), Colors.greenAccent),
                      SizedBox(height: 20),
                      // Balance Info - Dynamic content here
                      _buildInfoCard('Balance', _isLoading ? 'Loading...' : (_balance ?? '100.00'), Colors.greenAccent),
                      SizedBox(height: 20),
                      // Bus Management Section
                      Text(
                        "Bus Management",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Add a new button for viewing all drivers
                      GestureDetector(
                        onTap: () {
                          // Handle the action when this button is clicked
                          print("View All Buses clicked");
                          // You can navigate to a screen that lists all drivers, for example:
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BusTableScreen(onTap: () {  }, companyId: _companyId)),
                          );
                        },
                        child: Container(
                          width: double.infinity,  // Full width
                          height: 60,  // Less height
                          decoration: BoxDecoration(
                            color: Color(0x8C3A534D), // Same color
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          child: Center(
                            child: Text(
                              'View All Vehicles',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFeatureCard(
                            context,
                            'Add Bus',
                            Icons.directions_bus,
                            Color(0x8C3A534D),
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddBusScreen(companyId: _companyId),
                                ),
                              );
                            },
                          ),
                          _buildFeatureCard(
                            context,
                            'Delete Bus',
                            Icons.delete,
                            Color(0x8C3A534D),
                                () {
                              // Handle Delete Bus
                              print("Delete Bus clicked");
                            },
                          ),
                        ],
                      ),


                      SizedBox(height: 20),
                      // Driver/Driver Assistant Management Section
                      Text(
                        "Driver Management",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
// Add a new button for viewing all drivers
                      GestureDetector(
                        onTap: () {
                          // Handle the action when this button is clicked
                          print("View All Drivers clicked");
                          // You can navigate to a screen that lists all drivers, for example:
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DriverTableScreen(onTap: () {  }, companyId: _companyId)),
                          );
                        },
                        child: Container(
                          width: double.infinity,  // Full width
                          height: 60,  // Less height
                          decoration: BoxDecoration(
                            color: Color(0x8C3A534D), // Same color
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          child: Center(
                            child: Text(
                              'View All Drivers',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFeatureCard(context, 'Add Driver', Icons.person_add, Color(0x8C3A534D), () {
                            print('Company ID: $_companyId'); // Print the company ID
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddDriverScreen(onTap: () {  }, companyId: _companyId)),
                          );
                          }),
                          _buildFeatureCard(context, 'Remove Driver', Icons.person_remove, Color(0x8C3A534D), () {
                            // Handle Delete Driver
                            print("Delete Driver clicked");
                          }),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  // Function to build feature cards like Add/Delete Bus and Drivers
  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build balance and location info cards
  Widget _buildInfoCard(String title, String content, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Changed to black
            ),
            Text(
              content,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Changed to black
            ),
          ],
        ),
      ),
    );
  }
}
