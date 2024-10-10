import 'package:flutter/material.dart';

class RideSharingHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Commute History'),
        elevation: 0,
      ),
      body: Container(
        // Apply deep sea green gradient with low opacity
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade500.withOpacity(0.7),  // Light shade of deep sea green with low opacity
              Color(0xFF006B5F).withOpacity(0.9),     // Deep Sea Green with low opacity
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Text(
                'Trip History',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              // Page Subtitle
              Text(
                'Showing all your trips',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              SizedBox(height: 20),
              // Wrap in a SingleChildScrollView to avoid overflow
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderSection('Most recent trips'),
                      SizedBox(height: 20),
                      _buildOrderSection('Less recent trips'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build the order section (Active/Past orders)
  Widget _buildOrderSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 10),
        _buildOrderItem(),
        SizedBox(height: 10),
        _buildOrderItem(),
        if (title == 'Past orders') ...[
          SizedBox(height: 10),
          _buildOrderItem(),
        ]
      ],
    );
  }

  // Function to build individual order items
  Widget _buildOrderItem() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,  // White background for the order card
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_pin, color: Colors.greenAccent),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mohakhali',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'From',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Payment', style: TextStyle(color: Colors.grey)),
                  Text('12',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.flag, color: Colors.black),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Board Bazar'),
                    Text(
                      'Destination',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Distance', style: TextStyle(color: Colors.grey)),
                  Text('12Km', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
