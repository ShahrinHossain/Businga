import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'globalVariables.dart';
import 'journeyFinishedPage.dart';
import 'journeyStartedPage.dart';

var baseUrl = getIp();
bool inRoute = false;
int busId = 1;
int routeId = 1;

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCodeResult;
  double userBalance = 0.0;

  // Function to get the stored JWT token from SharedPreferences
  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Fetch user balance from the backend
  Future<void> fetchUserBalance() async {
    String? token = await getAuthToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/current/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          userBalance = userData['profile']['balance'].toDouble();
        });
      }
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  Future<void> startJourney() async {
    String? token = await getAuthToken();
    if (token == null) {
      print('User is not logged in');
      return;
    }

    // Fetch and check balance
    await fetchUserBalance();
    if (userBalance < 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Insufficient Balance"),
          content: Text("Your balance is too low to start a journey."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return;
    }

    double latitude = position.latitude;
    double longitude = position.longitude;

    // Get the current time for arrival_time
    String arrivalTime = DateTime.now().toIso8601String(); // Format in ISO8601

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/add-ongoing-trips/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'bus_id': 1,
          'route_id': routeId,
          'arrival_time': arrivalTime,
        }),
      );

      if (response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('inRoute', true);

        setState(() {
          inRoute = true;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JourneyStartedPage()),
        );
      } else {
        print('Failed to start journey: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> finishJourney() async {
    String? token = await getAuthToken();
    if (token == null) {
      print('User is not logged in');
      return;
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return;
    }

    double latitude = position.latitude;
    double longitude = position.longitude;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/finish-trip/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('inRoute', false);
        int busId = responseData['trip']['bus'] ?? 0;
        int routeId = responseData['trip']['route_id'] ?? 0;
        int tripNo = responseData['trip']['trip_no'] ?? 0;
        int fromId = responseData['trip']['from_id'] ?? 0;
        int toId = responseData['trip']['to_id'] ?? 0;
        double distance = (responseData['trip']['distance'] ?? 0).toDouble();
        double fare = (responseData['trip']['fare'] ?? 1.0).toDouble();

        String arrivalTime = responseData['trip']['arrival_time'] ?? "";
        String timestamp = responseData['trip']['timestamp'] ?? "";

        await prefs.setBool('inRoute', false);
        await prefs.setDouble('lastFare', fare);
        await prefs.setString('arrival_time', arrivalTime);
        await prefs.setString('departure_time', timestamp);
        await prefs.setInt('bus_id', busId);

        setState(() {
          inRoute = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JourneyFinishedPage()),
        );
      } else {
        print('Failed to end journey: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> getRouteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedInRoute = prefs.getBool('inRoute');

    String? token = await getAuthToken();
    if (token == null) {
      print('User is not logged in');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/current/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          inRoute = userData['profile']['in_route'];
        });

        await prefs.setBool('inRoute', inRoute);
      } else {
        setState(() {
          inRoute = savedInRoute ?? false;
        });
      }
    } catch (e) {
      setState(() {
        inRoute = savedInRoute ?? false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRouteStatus();
    fetchUserBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: Text('Businga'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  qrCodeResult != null ? 'QR Code: $qrCodeResult' : 'Scan a code',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: qrCodeResult == null
                  ? null
                  : inRoute
                  ? finishJourney
                  : startJourney,
              style: ElevatedButton.styleFrom(
                backgroundColor: qrCodeResult == null ? Colors.grey : Colors.teal[300],
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                inRoute ? 'End Journey' : 'Start Journey',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeResult = scanData.code;
        busId = int.tryParse(qrCodeResult ?? '1') ?? 1;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
