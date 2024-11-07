import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_or_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data == true) {
          return HomeScreen();
        } else {
          return const LogInPr();
        }
      },
    );
  }
}
