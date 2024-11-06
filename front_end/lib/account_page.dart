import 'package:flutter/material.dart';
import 'ride_sharehstry.dart';  // Import the Ride Sharing History page
import 'transaction_hstry.dart';  // Import the Transaction History page

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Activities',
          style: TextStyle(
            color: Colors.white, // Set title color to white
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF006B5F), // Apply the deep sea green color
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Ensure icon is white
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0), // Matching padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Select Option',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),

            // Button for Ride Sharing History
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RideSharingHistoryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                backgroundColor: Color(0xFF006B5F), // Use the deep sea green color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                'Commute History',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Text color to white
                ),
              ),
            ),
            SizedBox(height: 20),

            // Button for Transaction History
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TransactionHistoryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.greenAccent, // Keeping green accent for variety
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black, // Text color for contrast
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
