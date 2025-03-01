import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'navigation.dart';
import 'route_selection_page.dart';
import 'top_up_page.dart';
import 'tour_page.dart';
import 'account_page.dart';
import 'settings.dart';
import 'payment_page.dart';
import 'package:flutter/services.dart';
import 'globalVariables.dart';

var baseUrl = getIp(); // Dynamically fetch the base URL

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _balance; // Stores the fetched balance
  bool _isLoading = true; // Tracks if the balance is being loaded
  String? _username; // Stores the current user's username

  // Function to get the stored JWT token from SharedPreferences
  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');  // Get the stored token
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

  // Function to fetch the balance from the API
  // Future<void> _fetchBalance() async {
  //   final url = Uri.parse('$baseUrl/users/current/'); // API endpoint for user info
  //   try {
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       setState(() {
  //         _balance = data['balance']?.toString() ?? 'N/A'; // Extract balance from the API response
  //         _isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         _balance = '100.00';
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (error) {
  //     setState(() {
  //       _balance = '100.00';
  //       _isLoading = false;
  //     });
  //   }
  // }

  // Method to handle bottom navigation taps
  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to the AccountPage
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AccountPage()),
      );
    } else if (index == 3) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SettingsPage())
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,  // This keeps the layout fixed when the keyboard appears
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 60, // Adjust height of AppBar if necessary
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal[800]), // Go Back Icon
          onPressed: () {
            SystemNavigator.pop();  // Exits the app
          },
        ),
        title: Text(
          'Businga',  // App Name at the top
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
                      // "Where to?" Bar
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0), // Adjusted padding
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Where to?',
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
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Routes and Top-up Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFeatureCard(context, 'Routes', Icons.directions, Colors.greenAccent, RouteSelectionPage()),
                          _buildFeatureCard(context, 'Top-up', Icons.account_balance_wallet, Colors.greenAccent, PaymentPage()),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Balance Info - Dynamic content here
                      _buildInfoCard('Balance', _isLoading ? 'Loading...' : (_balance ?? '100.00'), Colors.greenAccent),
                      SizedBox(height: 20),
                      // Location Info
                      _buildInfoCard('Location', 'K B Bazar Road, Gazipur', Colors.greenAccent),
                      SizedBox(height: 20),
                      // Tour Section
                      Container(
                        width: double.infinity,
                        height: 150,  // Adjust height to fit your design
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[200],
                        ),
                        child: Stack(
                          children: [
                            // Background Bus Image with reduced opacity
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.6,  // Adjust the opacity value (0.0 is fully transparent, 1.0 is fully opaque)
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),  // Ensures the image respects the container's border radius
                                  child: Image.asset(
                                    'assets/bus.png', // Replace with your bus image asset
                                    fit: BoxFit.fill,  // Fills the entire area
                                  ),
                                ),
                              ),
                            ),
                            // Foreground content
                            Center(  // Centers the content in the container
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Not sure how the app works?",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigate to the NavigationPage
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => NavigationPage()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text("Take a Tour",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Function to build feature cards like Routes and Top-up
  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => nextPage));
      },
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
