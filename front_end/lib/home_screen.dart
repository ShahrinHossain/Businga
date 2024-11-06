import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'main.dart';
import 'route_selection_page.dart';
import 'top_up_page.dart';
import 'tour_page.dart';
import 'navigation.dart';
import 'account_page.dart';
import 'settings.dart';
import 'payment_page.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
      // Import to use SystemNavigator

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
                      // Balance Info
                      _buildInfoCard('Balance', 'BDT 345.50', Colors.greenAccent),
                      SizedBox(height: 20),
                      // Location Info
                      _buildInfoCard('Location', 'K B Bazar Road, Gazipur', Colors.greenAccent),
                      SizedBox(height: 20),
                      // Tour Section
                      // Tour Section
                      // Tour Section
                      // Tour Section
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
        onTap: _onItemTapped, // Handle tap
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Stops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        selectedItemColor: Colors.blueGrey[500],
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // Widget to build feature card (Routes, Top-up)
  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, Widget nextPage) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        child: Container(
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.black),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to build information card (Balance, Location)
  Widget _buildInfoCard(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
