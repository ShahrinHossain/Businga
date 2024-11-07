import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUserIn() async {
    final url = Uri.parse('http://0.0.0.0:8000/users/login/');
    final response = await http.post(url, body: {
      'username': emailController.text,
      'password': passwordController.text,
    });

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(jsonDecode(response.body)['error'] ?? 'Unknown error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
              controller: emailController,
              hintText: 'Username',
              obscureText: false,
            ),
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            MyButton(
              text: "Sign In",
              onTap: signUserIn,
            ),
          ],
        ),
      ),
    );
  }
}
