import 'package:flutter/material.dart';
import 'opening_pages/splash_page.dart';

void main() => runApp(EyeCapture());

class EyeCapture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
        buttonColor: Colors.blueGrey,
      ),
      home: EyeCaptureSplashScreen(),
    );
  }
}

