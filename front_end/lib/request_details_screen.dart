import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'globalVariables.dart';
import 'home_screen_admin.dart'; // For base64 decoding and JSON encoding

var baseUrl = getIp();

class RequestDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> request;

  RequestDetailsScreen({required this.request});

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Get the stored token
  }

  // Function to handle the "Verify and Register" button press
  void _handleVerifyAndRegister(BuildContext context) async {
    // Prepare the data for the API request
    String? token = await getAuthToken();

    final Map<String, dynamic> requestData = {
      'username': 'SabithHossain',
      'email': request['email_address'],
      'role': 'owner',
      'company_name': request['business_name'],
      'password': 'abcd1234', // Default password
    };

    try {
      // Send a POST request to the register API
      final response = await http.post(
        Uri.parse('$baseUrl/users/register/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      // Check the response status code
      if (response.statusCode == 201) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Owner registered successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreenAdmin(), // Replace with your actual home screen widget
          ),
        );
      } else {
        // Registration failed
        final Map<String, dynamic> responseBody = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register owner: ${responseBody['error'] ?? 'Unknown error'}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID
              Text(
                'ID: ${request['id'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // Full Name
              Text(
                'Full Name: ${request['full_name'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // Phone Number
              Text(
                'Phone Number: ${request['phone_number'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // Email Address
              Text(
                'Email Address: ${request['email_address'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // Residential Address
              Text(
                'Residential Address: ${request['residential_address'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // National ID
              Text(
                'National ID: ${request['national_id'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // Business Name
              Text(
                'Business Name: ${request['business_name'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // Business Registration Number
              Text(
                'Business Registration Number: ${request['business_registration_number'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // Tax Identification Number
              Text(
                'Tax Identification Number: ${request['tax_identification_number'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 10),

              // BRTA Certificate Number
              Text(
                'BRTA Certificate Number: ${request['brta_certificate_number'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.grey),
              SizedBox(height: 20),

              // BRTA Certificate Scan
              if (request['brta_certificate_scan'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BRTA Certificate Scan:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.memory(
                        base64Decode(request['brta_certificate_scan']),
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),

              // National ID Scan
              if (request['national_id_scan'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'National ID Scan:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.memory(
                        base64Decode(request['national_id_scan']),
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),

              // Business Registration Scan
              if (request['business_registration_scan'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business Registration Scan:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.memory(
                        base64Decode(request['business_registration_scan']),
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),

              // Verify and Register Button
              Center(
                child: ElevatedButton(
                  onPressed: () => _handleVerifyAndRegister(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Button color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Verify and Register'),
                ),
              ),
              SizedBox(height: 20), // Add some space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}