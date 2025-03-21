import 'package:businga1/owner_register_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';
import 'home_screen_driver.dart';
import 'loading_screen.dart';
import 'globalVariables.dart';
import 'owner_register_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

var baseUrl = getIp();

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final Map<String, String> loginData = {
      'username': emailController.text,
      'password': passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginData),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final String accessToken = responseBody['access'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoadingScreen()),
        );
      } else {
        final error = json.decode(response.body)['error'];
        showErrorDialog(error ?? 'An error occurred. Please try again.');
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorDialog('An error occurred. Please try again.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.redAccent,
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004D40), Color(0xFF002D2A)], // Deep Green → Deep Blue-Green
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Bus Icon
                    Image.asset('lib/images/bussinga.png', width: 200),

                    const SizedBox(height: 20),

                    // Welcome Back Text
                    // Text(
                    //   'Welcome Back!',
                    //   style: TextStyle(
                    //     fontSize: 23,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //     shadows: [
                    //       Shadow(
                    //         blurRadius: 5,
                    //         color: Colors.black26,
                    //         offset: Offset(2, 3),
                    //       ),
                    //     ],
                    //     letterSpacing: 1.2,
                    //   ),
                    // ),

                    const SizedBox(height: 30),

                    // Username & Password Fields
                    _buildTextField(emailController, 'Username', false, Icons.person),
                    _buildTextField(passwordController, 'Password', true, Icons.visibility),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Don't forget password",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Sign In Button
                    _buildSignInButton(),

                    const SizedBox(height: 20),

                    // Register Section
                    const Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 5),

                    _buildRegisterButton(),

                    const SizedBox(height: 15),

                    // Owner Signup Section
                    const Text(
                      "Want to join as a company owner?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 5),

                    _buildOwnerSignupButton(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isPassword, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword ? !isPasswordVisible : false,
          decoration: InputDecoration(
            hintText: isPassword ? '••••••••' : 'Enter your $label',
            hintStyle: TextStyle(color: Colors.white54),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            )
                : Icon(icon, color: Colors.white70),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: signUserIn,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'SIGN IN',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'SIGN UP',
            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerSignupButton() {
    return GestureDetector(
        onTap: () {
          // Navigate to the OwnerSignupScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OwnerRegisterForm(),
            ),
          );
        },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 7), // Smaller button
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: const Center(
          child: Text(
            'OWNER SIGNUP',
            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w200),
          ),
        ),
      ),
    );
  }
}
