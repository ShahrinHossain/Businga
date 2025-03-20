import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'globalVariables.dart';

var baseUrl = getIp();
const deepSeaGreen = Color(0xFF00756A);

class BusTableScreen extends StatefulWidget {
  final Function()? onTap;
  final int? companyId;
  const BusTableScreen({super.key, required this.onTap, this.companyId});

  @override
  State<BusTableScreen> createState() => _BusTableScreenState();
}

class _BusTableScreenState extends State<BusTableScreen> {
  List<dynamic> buses = []; // List to store bus data

  @override
  void initState() {
    super.initState();
    fetchBuses(); // Fetch buses when the page loads
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // Get the stored token
  }

  Future<void> fetchBuses() async {
    String? token = await getAuthToken();
    if (token == null) {
      print('User is not logged in');
      return;
    }

    final url = Uri.parse('$baseUrl/users/buses/${widget.companyId}'); // API URL

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Add authentication header
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          buses = data; // Update bus list
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to load buses"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred while fetching buses"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              'Bus List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buses.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: buses.length,
          itemBuilder: (context, index) {
            final bus = buses[index];
            return GestureDetector(
              onTap: () {
                // Show the dialog with the additional details when tapped
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.greenAccent, // Dialog background
                      title: Text(
                        'Bus Details',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Registration No: ${bus['registration_no']}',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Text(
                            'Condition: ${bus['condition'] ?? 'N/A'}',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Text(
                            'AC Status: ${bus['ac_status'] ? 'AC Available' : 'Non-AC'}',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Text(
                            'Location: ${bus['location'] ?? 'N/A'}',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFF006B5F),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    'Bus: ${bus['registration_no']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Condition: ${bus['condition']}',
                        style: TextStyle(
                          color: Colors.teal[800],
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Location: ${bus['location']}',
                        style: TextStyle(
                          color: Colors.teal[800],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    bus['ac_status'] ? Icons.ac_unit : Icons.airline_seat_recline_normal,
                    color: bus['ac_status'] ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {},
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
        selectedItemColor: Colors.teal[700],
      ),
    );
  }
}
