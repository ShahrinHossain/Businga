import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globalVariables.dart';

var baseUrl = getIp();
const deepSeaGreen = Color(0xFF00756A);

class AddDriverScreen extends StatefulWidget {
  final Function()? onTap;
  final int? companyId;
  const AddDriverScreen({super.key, required this.onTap, this.companyId});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController licenseNoController = TextEditingController();

  Future<void> registerDriver() async {
    final url = Uri.parse('$baseUrl/users/register/');

    final Map<String, dynamic> requestBody = {
      "username": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text,
      "role": "driver",
      "company_id": widget.companyId, // Replace with actual company_id
      "license_no": licenseNoController.text.trim(),
      "company_name": "" // Not needed but required by serializer
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Driver registered successfully"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Registration failed"),
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
              'Add Driver',
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
        child: Column(
          children: [
            buildTextField(nameController, "Name"),
            buildTextField(emailController, "Email", TextInputType.emailAddress),
            buildTextField(passwordController, "Password", TextInputType.text, true),
            buildTextField(licenseNoController, "License No"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerDriver,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Register Driver", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
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

  Widget buildTextField(TextEditingController controller, String label, [TextInputType type = TextInputType.text, bool obscureText = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        obscureText: obscureText,
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
