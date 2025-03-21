import 'package:businga1/start_bus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'globalVariables.dart';
import 'home_screen_driver.dart';
import 'home_screen.dart';
import 'home_screen_owner.dart';
import 'login_screen.dart';
import 'home_screen_owner.dart';
import 'home_screen_admin.dart';
import 'start_bus.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _checkUserRole() async {
    String? token = await getAuthToken();
    if (token == null) {
      // Redirect to login if token is not found
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${getIp()}/users/current/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        String role = userData['profile']['role'] ?? '';
        bool onDuty = userData['profile']['in_route'] ?? '';
        int userId = userData['id'];

        if (role == 'user') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else if (role == 'driver') {
          if(!onDuty) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => StartBus(userId: userId)),
            );
          }
          else{
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DriverHomeScreen()),
            );
          }
        } else if (role == 'owner') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BusOwnerHomeScreen()),
          );
        } else if (role == 'admin'){
        Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => HomeScreenAdmin()),
          );
        }
        else {
          // Handle unknown role (optional)
          print('Unknown role: $role');
        }
      } else {
        print('Failed to fetch user data: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.teal[800],
        ),
      ),
    );
  }
}
