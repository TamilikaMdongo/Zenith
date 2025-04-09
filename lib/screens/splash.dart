import 'package:flutter/material.dart';
import 'package:app/screens/bottom_navbar.dart';
import 'package:app/screens/register.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 5 seconds then navigate to the next page
    Future.delayed(Duration(seconds: 5), () {
      // Route to the next page after 5 seconds
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Register()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Container(
              height: 400,
              width: 600,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 350),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:500.0),
            child: const Text('Disclaimer: Please note that our app is currently in the beta phase. While we’re excited to share it with you, not all features are fully implemented, and there may be occasional bugs or performance issues. We appreciate your feedback as we continue to improve the platform, and we thank you for your patience during this early stage'),
          )
        ],
      ),
    );
  }
}
