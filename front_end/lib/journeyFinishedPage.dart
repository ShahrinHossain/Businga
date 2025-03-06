import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class JourneyFinishedPage extends StatefulWidget {
  @override
  _JourneyFinishedPageState createState() => _JourneyFinishedPageState();
}

class _JourneyFinishedPageState extends State<JourneyFinishedPage> {
  String arrivalTime = '';
  String departureTime = '';
  int busId = 0;
  Duration journeyDuration = Duration.zero;
  double fare = 0.0; // Add this for fare

  @override
  void initState() {
    super.initState();
    loadJourneyData();
  }

  Future<void> loadJourneyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? arrival = prefs.getString('arrival_time');
    String? departure = prefs.getString('departure_time');
    int? bus = prefs.getInt('bus_id');
    double? totalFare = prefs.getDouble('lastFare'); // Fetch fare from SharedPreferences

    if (arrival != null && departure != null) {
      DateTime arrivalDT = DateTime.parse(arrival);
      DateTime departureDT = DateTime.parse(departure);
      setState(() {
        arrivalTime = DateFormat('hh:mm a, dd MMM yyyy').format(arrivalDT);
        departureTime = DateFormat('hh:mm a, dd MMM yyyy').format(departureDT);
        journeyDuration = arrivalDT.difference(departureDT);
        busId = bus ?? 0;
        fare = totalFare ?? 0.0; // Set the fare
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Journey Finished')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              'Journey Completed!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display total fare in the middle with increased font size
            Text(
              'Fare: BDT ${fare.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 32, // Larger font size
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            _infoRow('Bus ID', busId.toString()),
            _infoRow('Departure Time', departureTime),
            _infoRow('Arrival Time', arrivalTime),
            _infoRow('Journey Duration', formatDuration(journeyDuration)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }
}
