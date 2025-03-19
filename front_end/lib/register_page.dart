import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'globalVariables.dart';

var baseUrl = getIp();
const deepSeaGreen = Color(0xFF00756A);

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String selectedRole = '';

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: deepSeaGreen),
        );
      },
    );

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      wrongPasswordMessage("Passwords don't match");
      return;
    }

    // if (selectedRole.isEmpty) {
    //   Navigator.pop(context);
    //   wrongPasswordMessage("Please select a role");
    //   return;
    // }

    Navigator.pop(context); // Close loading indicator

    // Map the selectedRole to the corresponding role string
    String mappedRole = '';
    switch (selectedRole) {
      case 'passenger':
        mappedRole = 'User';
        break;
      default:
        mappedRole = 'User';
    }

    completeRegistration(mappedRole);
  }

  void completeRegistration(String role) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: deepSeaGreen),
        );
      },
    );

    final Map<String, String> registrationData = {
      'email': emailController.text,
      'username': usernameController.text,
      'password': passwordController.text,
      'role': role,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(registrationData),
      );

      Navigator.pop(context); // Close loading indicator

      if (response.statusCode == 201) {
        // Always navigate to login page after successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Please log in.'),
            backgroundColor: Colors.teal[800],
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(onTap: widget.onTap)), // Ensure onTap is passed
          );
        });
      } else {
        final error = json.decode(response.body)['error'];
        wrongPasswordMessage(error ?? 'An error occurred. Please try again.');
      }
    } catch (e) {
      Navigator.pop(context);
      wrongPasswordMessage('An error occurred. Please try again.');
    }
  }

  void wrongPasswordMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: deepSeaGreen,
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
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
                // const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 40),
                //   child: Text(
                //     'Choose your role:',
                //     style: TextStyle(
                //       fontSize: 18,
                //       color: Colors.grey[700],
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 60),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       roleSelectionBox('Bus Owner', 'bus_owner'),
                //       roleSelectionBox('Passenger', 'passenger'),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 40),
                //   child: roleSelectionBox('Passenger', 'passenger'),
                // ),
                const SizedBox(height: 20),
                inputField(emailController, 'Email'),
                const SizedBox(height: 10),
                inputField(usernameController, 'Username'),
                const SizedBox(height: 10),
                inputField(passwordController, 'Password', obscureText: true),
                const SizedBox(height: 10),
                inputField(confirmPasswordController, 'Confirm Password', obscureText: true),
                const SizedBox(height: 25),
                signUpButton(),
                const SizedBox(height: 50),
                loginOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget roleSelectionBox(String title, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedRole == value ? deepSeaGreen : Colors.teal[800],
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget inputField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepSeaGreen,
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: signUserUp,
        child: const Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget loginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account?', style: TextStyle(color: Colors.grey[700])),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: widget.onTap,
          child: const Text('Login Now', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
