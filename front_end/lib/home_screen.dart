import 'package:businga1/route_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigation.dart';
import 'route_selection_page.dart';
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
  TextEditingController _searchController = TextEditingController();
  List<String> _suggestions = [];
  List<String> _suggestionIds = [];
  bool _showClearButton = false; // Tracks if the "X" should be shown

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


// Function to fetch place details and print coordinates
  Future<Map<String, double>> fetchPlaceDetails(String placeId) async {
    const String apiKey = 'AIzaSyB9C6viTxdaZbqrwtU8KqRxyIYTT1AmXYA';
    print(placeId);

    final response = await http.get(
      Uri.parse('https://places.googleapis.com/v1/places/$placeId'),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask': 'location',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.containsKey('location')) {
        double latitude = data['location']['latitude'];
        double longitude = data['location']['longitude'];

        // Return coordinates as a Map
        return {
          'lat': latitude,
          'lng': longitude,
        };
      } else {
        print('Location data is missing');
        return {};
      }
    } else {
      print('Failed to fetch place details: ${response.body}');
      return {};
    }
  }

  // Function to fetch place suggestions from Google Places API
  Future<void> fetchPlaceSuggestions(String input) async {
    const String apiKey = 'AIzaSyB9C6viTxdaZbqrwtU8KqRxyIYTT1AmXYA';

    // Get the device's current location
    Position position = await _determinePosition();
    double latitude = position.latitude;
    double longitude = position.longitude;

    final response = await http.post(
      Uri.parse('https://places.googleapis.com/v1/places:autocomplete'),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
      },
      body: json.encode({
        'input': input,
        'locationBias': {
          'circle': {
            'center': {'latitude': latitude, 'longitude': longitude},
            'radius': 500.0
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions = [];
      List<String> suggestionIDs = [];
      for (var suggestion in data['suggestions']) {
        suggestions.add(suggestion['placePrediction']['text']['text']);
        suggestionIDs.add(suggestion['placePrediction']['placeId']);
      }
      setState(() {
        _suggestions = suggestions;
        _suggestionIds = suggestionIDs;
      });
    } else {
      print('Failed to fetch place suggestions: ${response.body}');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return a default position
      throw Exception('Location services are disabled.');
    }

    // Check if we have permission to access the location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If permission is denied, throw an error
        throw Exception('Location permission denied');
      }
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Function to clear the search input and suggestions
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _suggestions = [];
      _showClearButton = false;
    });
  }




  @override
  void initState() {
    super.initState();
    getUserData(); // Fetch user data when screen loads
  }

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
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: _searchController.text.isEmpty ? null : _clearSearch,
                                    child: Icon(
                                      _searchController.text.isEmpty ? Icons.search : Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    fetchPlaceSuggestions(value);
                                  } else {
                                    setState(() {
                                      _suggestions.clear();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Suggestions list as a layered widget
                      if (_suggestions.isNotEmpty)
                        Positioned(
                          top: 100, // Adjust the top position based on your UI
                          left: 20,
                          right: 20,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(_suggestions[index]),
                                    onTap: () async {
                                      print(_suggestions);
                                      // Get the place details (coordinates) for the tapped suggestion
                                      String placeName = _suggestions[index];  // Name of the tapped place
                                      String placeId = _suggestionIds[index];
                                      // Fetch place details using placeId
                                      var placeDetails = await fetchPlaceDetails(placeId);

                                      // Assume placeDetails returns the coordinates (latitude, longitude)
                                      double? destinationLat = placeDetails['lat'];
                                      double? destinationLng = placeDetails['lng'];

                                      // Get current location (for source coordinates)
                                      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                      double srcLat = currentPosition.latitude;
                                      double srcLng = currentPosition.longitude;

                                      // Save both coordinates to SharedPreferences
                                      SharedPreferences prefs = await SharedPreferences.getInstance();

                                      // Save source and destination coordinates
                                      await prefs.setDouble('src_lat', srcLat);
                                      await prefs.setDouble('src_lng', srcLng);
                                      await prefs.setDouble('dest_lat', destinationLat!);
                                      await prefs.setDouble('dest_lng', destinationLng!);

                                      // Show confirmation
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Selected Destination: $placeName")),
                                      );

                                      // Navigate to RouteView page
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => RouteView()),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 20),
                      // Routes and Top-up Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // _buildFeatureCard(context, 'Routes', Icons.directions, Colors.greenAccent, RouteSelectionPage(), textColor: Colors.black),
                          _buildFeatureCard(context, 'Top-up', Icons.account_balance_wallet, Colors.greenAccent, const Checkout(), textColor: Colors.black),
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
            icon: Icon(Icons.local_taxi),
            label: 'Routes',
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
  // Updated Feature Card Function
  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, Widget nextPage, {Color textColor = Colors.black}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => nextPage));
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          width: 335,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.black),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: textColor), // Now text color can be changed dynamically
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
