import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace 'localhost' with your actual IP address if accessing from a different device
  final String baseUrl = 'http://127.0.0.1:8000/users';

  Future<void> fetchMessage() async {
    final response = await http.get(Uri.parse('$baseUrl/example/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Message from Django: ${data['message']}');
    } else {
      print('Failed to load data');
    }
  }

  Future<void> sendData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/example/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 201) {
      print('Data sent successfully: ${json.decode(response.body)}');
    } else {
      print('Failed to send data');
    }
  }
}
