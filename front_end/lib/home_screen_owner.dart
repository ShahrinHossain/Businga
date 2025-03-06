import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'globalVariables.dart';

var baseUrl = getIp(); // Dynamically fetch the base URL

class BusOwnerHomeScreen extends StatefulWidget {
  @override
  _BusOwnerHomeScreenState createState() => _BusOwnerHomeScreenState();
}

class _BusOwnerHomeScreenState extends State<BusOwnerHomeScreen> {
  int _selectedIndex = 0;
  String? _balance; // Stores the fetched balance
  bool _isLoading = true; // Tracks if the balance is being loaded
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
      final response = await http.get(
        Uri.parse('$baseUrl/users/current/'),
        headers: {
          'Authorization': 'Bearer $token', // Add token in Authorization header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Handle success
        final userData = json.decode(response.body);
        setState(() {
          _username = userData['username'];
          _balance = userData['profile']['balance']?.toString() ?? 'N/A'; // Extract balance from the API response
          _isLoading = false;
        });
      } else {
        setState(() {
          _balance = '100.00';
          _isLoading = false;
        });
        // Handle failure (e.g., unauthorized)
        print('Failed to fetch user data: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _balance = '100.00';
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
        toolbarHeight: 60, // Adjust height of AppBar if necessary
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal[800]), // Go Back Icon
          onPressed: () {
            SystemNavigator.pop(); // Exits the app
          },
        ),
        title: Text(
          'Businga', // App Name at the top
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800], // Deep sea green
          ),
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
                      // Bus Management Section
                      Text(
                        "Bus Management",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFeatureCard(context, 'Add Bus', Icons.directions_bus, Colors.blue, () {
                            // Handle Add Bus
                            print("Add Bus clicked");
                          }),
                          _buildFeatureCard(context, 'Delete Bus', Icons.delete, Colors.red, () {
                            // Handle Delete Bus
                            print("Delete Bus clicked");
                          }),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Driver/Driver Assistant Management Section
                      Text(
                        "Driver Management",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFeatureCard(context, 'Add Driver', Icons.person_add, Colors.green, () {
                            // Handle Add Driver
                            print("Add Driver clicked");
                          }),
                          _buildFeatureCard(context, 'Delete Driver', Icons.person_remove, Colors.orange, () {
                            // Handle Delete Driver
                            print("Delete Driver clicked");
                          }),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFeatureCard(context, 'Add Assistant', Icons.person_add_alt_1, Colors.purple, () {
                            // Handle Add Driver Assistant
                            print("Add Driver Assistant clicked");
                          }),
                          _buildFeatureCard(context, 'Delete Assistant', Icons.person_remove_alt_1, Colors.pink, () {
                            // Handle Delete Driver Assistant
                            print("Delete Driver Assistant clicked");
                          }),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Balance Info - Dynamic content here
                      _buildInfoCard('Balance', _isLoading ? 'Loading...' : (_balance ?? '100.00'), Colors.greenAccent),
                      SizedBox(height: 20),
                      // Location Info
                      _buildInfoCard('Location', 'K B Bazar Road, Gazipur', Colors.greenAccent),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}