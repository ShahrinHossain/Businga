// import 'package:flutter/material.dart';
// import 'login_page.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Uber-like App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(onTap: onTap),
//     );
//   }
// }



// import 'package:firebase_core/firebase_core.dart';
import 'auth_page.dart';
// import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'services/apiTest.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiService = ApiService();

  // Fetch data
  // await apiService.fetchMessage();

  // Send data
  // await apiService.sendData({'name': 'Django', 'message': 'Hello, Flutter!'});
  runApp(const MyApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}