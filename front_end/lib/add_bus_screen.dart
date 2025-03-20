import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'globalVariables.dart';

var baseUrl = getIp();
const deepSeaGreen = Color(0xFF00756A);

class AddBusScreen extends StatefulWidget {
  final int? companyId;

  AddBusScreen({required this.companyId});

  @override
  _AddBusScreenState createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController registrationController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool _isLoading = false;
  int acStatus = 1; // Default: AC
  String condition = "Good"; // Default condition

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Function to add a bus to the database
  Future<void> _addBus() async {
    final url = Uri.parse('${getIp()}/users/add-bus/');

    final Map<String, dynamic> requestBody = {
      "registration_no": registrationController.text.trim(),
      "condition": condition,
      "ac_status": acStatus,
      "location": locationController.text.trim(),
      "company_id": widget.companyId, // Replace with actual company_id
    };

    try {
      final token = await getAuthToken();
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Authentication token not found"),
          backgroundColor: Colors.red,
        ));
        return;
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Bus added successfully"),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context); // Close the screen after success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to add bus: ${response.body}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred"),
        backgroundColor: Colors.red,
      ));
    }
  }




  // Retrieve auth token from shared preferences


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
              'Add Bus',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
          ],
        ),
      ),
    body: SingleChildScrollView(  // Wrap the body in a SingleChildScrollView
    child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Registration Number Input
            buildTextField(registrationController, "Registration Number"),
            SizedBox(height: 10),
            buildTextField(locationController, "Location"),
            SizedBox(height: 20),

            // AC Status Input (AC or Non-AC)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // This will space the text and buttons out
              children: [
                Text(
                  'AC Status: ',
                  style: TextStyle(fontSize: 16, color: Colors.black), // Adjust the style as needed
                ),
                Row(
                  children: [
                    // AC button
                    SizedBox(
                      width: 120, // Set the desired width for both buttons
                      child: ElevatedButton(
                        onPressed: () => setState(() => acStatus = 1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: acStatus == 1 ? deepSeaGreen : Colors.grey,
                        ),
                        child: Text('AC', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Non-AC button
                    SizedBox(
                      width: 120, // Set the same width as the AC button
                      child: ElevatedButton(
                        onPressed: () => setState(() => acStatus = 0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: acStatus == 0 ? deepSeaGreen : Colors.grey,
                        ),
                        child: Text('Non-AC', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),


            SizedBox(height: 10),

            // Condition Input (Good, Excellent, Average, Bad)
            // Condition Input (Good, Excellent, Average, Bad)
            // Vehicle Condition Input (Good, Excellent, Average, Bad)
            // Vehicle Condition Input (Good, Excellent, Average, Bad)
// Vehicle Condition Input (Good, Excellent, Average, Bad)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      'Vehicle Condition: ',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Add spacing between label and first row of buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center buttons
                  children: [
                    // Buttons for Good and Excellent
                    for (var cond in ["Good", "Excellent"])
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          width: 165, // Ensure buttons have the same width
                          child: ElevatedButton(
                            onPressed: () => setState(() => condition = cond),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: condition == cond ? deepSeaGreen : Colors.grey,
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text(cond, style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10), // Add spacing between the first and second row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center buttons
                  children: [
                    // Buttons for Average and Bad
                    for (var cond in ["Average", "Bad"])
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          width: 165, // Ensure buttons have the same width
                          child: ElevatedButton(
                            onPressed: () => setState(() => condition = cond),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: condition == cond ? deepSeaGreen : Colors.grey,
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text(cond, style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),



            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addBus,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Register Bus", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
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

  Widget buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal[700]!),
          ),
        ),
      ),
    );
  }
}
