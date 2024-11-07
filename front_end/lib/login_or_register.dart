import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class LogInPr extends StatefulWidget{
  const LogInPr({super.key});

  @override
  State <LogInPr> createState() => _LogInPrState();
}

class _LogInPrState extends State<LogInPr>{
  bool showLogInPage = true;

  void togglePages(){
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context){
      if(showLogInPage) {
        return LoginPage(onTap: togglePages,
        );
      }
      else {
        return RegisterPage( onTap: togglePages);
      }
  }
}