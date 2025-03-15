import 'package:flutter/material.dart';

class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Out'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to log out?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Logging out will remove your access to the app. You can log back in at any time.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle log out
                      _logOut(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red color for emphasis
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      // Cancel and go back
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle log out
  void _logOut(BuildContext context) {
    // Perform log out logic here (e.g., clear user session, navigate to login screen)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have been logged out')),
    );

    // Navigate to the login screen or home screen after logging out
    Navigator.of(context).pushReplacementNamed('/login'); // Replace with your login route
  }
}