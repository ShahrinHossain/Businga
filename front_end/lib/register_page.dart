import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For parsing JSON responses
import 'components/my_button.dart';
import 'components/my_textfield.dart';
import 'components/square_tile.dart'; // Can be removed if not used anywhere else
import 'home_screen.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // Show loading dialog
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });

    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      wrongPasswordMessage("Passwords don't match");
      return;
    }

    // Prepare data for registration
    final Map<String, String> registrationData = {
      'username': emailController.text,
      'password': passwordController.text,
    };

    try {
      // Send POST request to Django backend
      final response = await http.post(
        Uri.parse('http://0.0.0.0:8000/register/'), // Your Django API endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(registrationData),
      );

      // Check response
      if (response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())); // Navigate to home after successful registration
      } else {
        Navigator.pop(context);
        final error = json.decode(response.body)['error'];
        wrongPasswordMessage(error ?? 'An error occurred. Please try again.');
      }
    } catch (e) {
      Navigator.pop(context);
      wrongPasswordMessage('An error occurred. Please try again.');
    }
  }

  void wrongPasswordMessage(String message) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.deepPurple,
        title: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome text
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign up button
                MyButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Removed the Google sign-in button part

                const SizedBox(height: 50),

                // already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
