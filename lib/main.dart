import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shortcut/dashboard_screen.dart';
// import 'package:shortcut/navigator.dart';

void main() {
  runApp(ShortCut());
}

class ShortCut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ShortCut Make Your Life Easy",
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Using a timer to navigate to the second screen after 2 seconds.
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 300,
          child: Image.asset("assets/images/logodes.png"),
        ),
      ),
    );
  }
}
