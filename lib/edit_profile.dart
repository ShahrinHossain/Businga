import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/siam.png'), // Load image from assets
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:  Color(0xFF006B5F),
                      child: Icon(Icons.camera_alt, size: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Name field
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'Sadman Sahil'),
            ),
            SizedBox(height: 20),
            // Email field
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'sadubaba@gmail.com'),
            ),
            SizedBox(height: 20),
            // Password field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: '**********'),
            ),
            SizedBox(height: 20),
            // Date of Birth field
            TextField(
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: '23/05/1995'),
            ),
            SizedBox(height: 20),
            // Country/Region field
            TextField(
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              controller: TextEditingController(text: 'Dhaka'),
            ),
            SizedBox(height: 30),
            // Save changes button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save changes action
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  backgroundColor: Color(0xFF006B5F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Save changes', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
