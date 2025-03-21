import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'globalVariables.dart';
import 'owner_request.dart'; // Import the OwnerRequest model
import 'request_details_screen.dart';

var baseUrl = getIp();

class HomeScreenAdmin extends StatefulWidget {
  @override
  _HomeScreenAdminState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  // Dummy data for bus owners and drivers
  final List<String> busOwners = ['Owner 1', 'Owner 2', 'Owner 3'];
  final List<String> busDrivers = ['Driver 1', 'Driver 2', 'Driver 3'];
  int _selectedIndex = 0;

   // List to store API response



  // Dummy data for transactions
  final Map<String, double> transactions = {
    'Today': 1500.0,
    'Yesterday': 1200.0,
    '2 Days Ago': 1000.0,
  };

  // Dummy data for user feedback
  final List<Map<String, String>> userFeedback = [
    {'user': 'User 1', 'feedback': 'Great service!', 'rating': '5/5'},
    {'user': 'User 2', 'feedback': 'Late arrival, but good otherwise.', 'rating': '4/5'},
    {'user': 'User 3', 'feedback': 'Driver was very polite.', 'rating': '5/5'},
  ];

  // Dummy data for notifications
  final List<String> notifications = [
    'New bus owner registered: Owner 4',
    'Driver 2 completed 50 trips today.',
    'System maintenance scheduled for tomorrow.',
  ];

  // Track unread notifications
  int unreadNotifications = 3; // Example: 3 unread notifications

  // List to store pending requests
  List<Map<String, dynamic>> userData = [];

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch pending requests when the screen loads
  }

  String formatCreatedAt(String createdAt) {
    // Parse the ISO 8601 date string
    DateTime dateTime = DateTime.parse(createdAt);

    // Format the date and time
    String formattedDate = DateFormat('MMMM d, y h:mm a').format(dateTime);

    return formattedDate;
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Get the stored token
  }

  Future<void> fetchData() async {
    String? token = await getAuthToken();
    if (token == null) {
      print('User is not logged in');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/fetch-owner-request/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          userData = List<Map<String, dynamic>>.from(data); // Store the response
        });
      } else {
        print('Failed to fetch data: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Admin Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
          ],
        ),
        actions: [
          // Notification Button with Badge
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.teal[800]),
                onPressed: () {
                  _showNotificationsDialog(context);
                },
              ),
              if (unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$unreadNotifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Overview Section
            Text(
              'Statistics Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
            ),
            SizedBox(height: 10),
            Container(
              height: 120, // Fixed height for the horizontal scrollable section
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStatCard('Total Rides', '1,234'),
                  _buildStatCard('Active Buses', '25'),
                  _buildStatCard('Revenue Today', '\৳1,500'),
                  _buildStatCard('Cancelled Rides', '12'),
                  _buildStatCard('New Users', '45'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Transactions Section as Dropdown
            ExpansionTile(
              title: Text(
                'Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
              ),
              children: transactions.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('\৳${entry.value.toString()}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // User Feedback Section as Dropdown
            ExpansionTile(
              title: Text(
                'User Feedback',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
              ),
              children: userFeedback.map((feedback) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(feedback['user']!),
                    subtitle: Text(feedback['feedback']!),
                    trailing: Text(feedback['rating']!),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Pending Requests Section as Dropdown
            ExpansionTile(
              title: Text(
                'Pending Requests',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
              ),
              children: userData.map((request) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(request['full_name'] ?? 'Unknown'),
                    subtitle: Text(
                      'Sent: ${formatCreatedAt(request['created_at'])}', // Display formatted date
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),// Use default value if null
                    onTap: () {
                      // Navigate to the RequestDetailsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestDetailsScreen(request: request),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        // onTap: (index) {
        //   setState(() {
        //     _selectedIndex = index;
        //   });
        // },
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

  // Helper method to build a stat card
  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 8), // Add horizontal margin
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
            ),
          ],
        ),
      ),
    );
  }

  // Show Notifications Dialog
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notifications ($unreadNotifications)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: notifications.map((notification) {
              return ListTile(
                leading: Icon(Icons.notifications, color: Colors.teal[800]),
                title: Text(notification),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  unreadNotifications = 0; // Mark all notifications as read
                });
                Navigator.of(context).pop();
              },
              child: Text('Mark All as Read'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Handle Accept Request
  void _handleAcceptRequest(String name) {
    print('Accepted request from $name');
    // Add logic to handle acceptance (e.g., update database, show confirmation, etc.)
  }

  // Handle Reject Request
  void _handleRejectRequest(String name) {
    print('Rejected request from $name');
    // Add logic to handle rejection (e.g., update database, show confirmation, etc.)
  }

  // Handle View Details
  void _handleViewDetails(String name, String details) {
    print('Viewing details for $name: $details');
    // Add logic to show details (e.g., navigate to a details screen, show a dialog, etc.)
  }
}