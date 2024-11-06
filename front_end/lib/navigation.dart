import 'package:flutter/material.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Take a Tour',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Home Page Overview'),
            _buildSectionContent(
                'This is your dashboard where you can check your balance, current location, and access routes or top-up your account.\n'
                    'Easily find common actions like "Routes" and "Top-up" for quick access.\n'
                    'Your current balance and location are always visible here for convenience.'),

            _buildSectionTitle('2. Search for Routes'),
            _buildSectionContent(
                'Use the search bar at the top to input your destination.\n'
                    'Select a route from the list of available routes based on your location and destination.\n'
                    'Tap on a route to see a detailed map and journey time.'),

            _buildSectionTitle('3. Journey Start'),
            _buildSectionContent(
                'Once you\'ve selected your route, scan the QR code provided to confirm your trip and begin your journey.\n'
                    'This feature ensures smooth boarding and real-time tracking.'),

            _buildSectionTitle('4. Activities Section'),
            _buildSectionContent(
                'Check all your previous journeys, top-ups, and transactions under the "Activities" section.\n'
                    'Keep track of your travel and expenses here.'),

            _buildSectionTitle('5. Managing Vehicles (For Drivers)'),
            _buildSectionContent(
                'In the "Account" section, drivers can add or manage vehicles, check driver information, and withdraw money.'),

            _buildSectionTitle('6. Customer Reviews'),
            _buildSectionContent(
                'View customer feedback under the "Customer Reviews" section.\n'
                    'The rating system allows you to read what other users have to say about their experiences.'),

            _buildSectionTitle('7. Help & Support'),
            _buildSectionContent(
                'If you\'re unsure how to use the app, this "Take a Tour" guide is always available.\n'
                    'Feel free to revisit this section to understand any new updates or features added to the app.'),
          ],
        ),
      ),
    );
  }

  // Method to build section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  // Method to build section content
  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
      ),
    );
  }
}
