/*import 'package:flutter/material.dart';

class HomeScreenAdmin extends StatelessWidget {
  // Dummy data for bus owners and drivers
  final List<String> busOwners = ['Owner 1', 'Owner 2', 'Owner 3'];
  final List<String> busDrivers = ['Driver 1', 'Driver 2', 'Driver 3'];

  // Dummy data for transactions
  final Map<String, double> transactions = {
    'Today': 1500.0,
    'Yesterday': 1200.0,
    '2 Days Ago': 1000.0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.tealAccent, // Match the theme color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bus Owners Section
            Text(
              'Bus Owners',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: busOwners.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(busOwners[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implement delete functionality
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement add bus owner functionality
              },
              child: Text('Add Bus Owner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent, // Use backgroundColor instead of primary
              ),
            ),
            SizedBox(height: 20),

            // Bus Drivers Section
            Text(
              'Bus Drivers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: busDrivers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(busDrivers[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implement delete functionality
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement add bus driver functionality
              },
              child: Text('Add Bus Driver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent, // Use backgroundColor instead of primary
              ),
            ),
            SizedBox(height: 20),

            // Transactions Section
            Text(
              'Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.tealAccent),
            ),
            SizedBox(height: 10),
            Column(
              children: transactions.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('\$${entry.value.toString()}'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreenAdmin extends StatelessWidget {
  // Dummy data for bus owners and drivers
  final List<String> busOwners = ['Owner 1', 'Owner 2', 'Owner 3'];
  final List<String> busDrivers = ['Driver 1', 'Driver 2', 'Driver 3'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.tealAccent, // Match the theme color
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Navigate to notifications screen
            },
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total Rides', '1,234'),
                _buildStatCard('Active Buses', '25'),
                _buildStatCard('Revenue Today', '\$1,500'),
              ],
            ),
            SizedBox(height: 20),

            // Bus Owners Section
            Text(
              'Bus Owners',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: busOwners.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(busOwners[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implement delete functionality
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement add bus owner functionality
              },
              child: Text('Add Bus Owner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent, // Match the theme color
              ),
            ),
            SizedBox(height: 20),

            // Bus Drivers Section
            Text(
              'Bus Drivers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: busDrivers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(busDrivers[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implement delete functionality
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement add bus driver functionality
              },
              child: Text('Add Bus Driver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent, // Match the theme color
              ),
            ),
            SizedBox(height: 20),

            // Transactions Section
            Text(
              'Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            Column(
              children: transactions.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('\$${entry.value.toString()}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Real-Time Bus Tracking Section
            Text(
              'Real-Time Bus Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Map View Here',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),

            // User Feedback Section
            Text(
              'User Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: userFeedback.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(userFeedback[index]['user']!),
                    subtitle: Text(userFeedback[index]['feedback']!),
                    trailing: Text(userFeedback[index]['rating']!),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Notifications Section
            Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            Column(
              children: notifications.map((notification) {
                return ListTile(
                  leading: Icon(Icons.notifications, color: Colors.tealAccent),
                  title: Text(notification),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a stat card
  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';

class HomeScreenAdmin extends StatelessWidget {
  // Dummy data for bus owners and drivers
  final List<String> busOwners = ['Owner 1', 'Owner 2', 'Owner 3'];
  final List<String> busDrivers = ['Driver 1', 'Driver 2', 'Driver 3'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.tealAccent, // Match the theme color
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Navigate to notifications screen
            },
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            Container(
              height: 120, // Fixed height for the horizontal scrollable section
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStatCard('Total Rides', '1,234'),
                  _buildStatCard('Active Buses', '25'),
                  _buildStatCard('Revenue Today', '\$1,500'),
                  _buildStatCard('Cancelled Rides', '12'),
                  _buildStatCard('New Users', '45'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Bus Owners Section
            Text(
              'Bus Owners',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: busOwners.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(busOwners[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implement delete functionality
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement add bus owner functionality
              },
              child: Text('Add Bus Owner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent, // Match the theme color
              ),
            ),
            SizedBox(height: 20),

            // Bus Drivers Section
            Text(
              'Bus Drivers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: busDrivers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(busDrivers[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implement delete functionality
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement add bus driver functionality
              },
              child: Text('Add Bus Driver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent, // Match the theme color
              ),
            ),
            SizedBox(height: 20),

            // Transactions Section
            Text(
              'Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            Column(
              children: transactions.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('\$${entry.value.toString()}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Real-Time Bus Tracking Section
            Text(
              'Real-Time Bus Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Map View Here',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),

            // User Feedback Section
            Text(
              'User Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: userFeedback.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(userFeedback[index]['user']!),
                    subtitle: Text(userFeedback[index]['feedback']!),
                    trailing: Text(userFeedback[index]['rating']!),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Notifications Section
            Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            Column(
              children: notifications.map((notification) {
                return ListTile(
                  leading: Icon(Icons.notifications, color: Colors.blue),
                  title: Text(notification),
                );
              }).toList(),
            ),
          ],
        ),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}