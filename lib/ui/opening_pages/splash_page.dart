import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EyeCaptureSplashScreen extends StatefulWidget {
  @override
  _EyeCaptureSplashScreenState createState() => _EyeCaptureSplashScreenState();
}

class _EyeCaptureSplashScreenState extends State<EyeCaptureSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            APP_NAME,
            style: TextStyle(
              color: Colors.white,
              fontSize: SPLASH_APP_NAME_FONT_SIZE,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.0),
          SpinKitThreeBounce(
            color: Colors.white,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
