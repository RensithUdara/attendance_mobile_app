import 'dart:async';

import 'package:attendanceapp/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Start the fade-out animation after 2 seconds
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0; // Begin fade-out
      });

      // Navigate to HomeScreen after the fade-out completes (1 second)
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        opacity: _opacity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App title
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Student",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: " Attendance",
                      style: TextStyle(
                        color: Colors.greenAccent.shade700,
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              // Version text
            ],
          ),
        ),
      ),
    );
  }
}
