import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/ui/opening_pages/patient_selection_page.dart';
import 'package:eye_capture/ui/opening_pages/splash_bloc.dart';
import 'package:eye_capture/ui/opening_pages/splash_event.dart';
import 'package:eye_capture/ui/opening_pages/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EyeCaptureSplashScreen extends StatefulWidget {
  @override
  _EyeCaptureSplashScreenState createState() => _EyeCaptureSplashScreenState();
}

class _EyeCaptureSplashScreenState extends State<EyeCaptureSplashScreen> {
  SplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = SplashBloc();
    _splashBloc.add(InitiateDataFetchEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _splashBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: BlocListener(
        bloc: _splashBloc,
        listener: (context, state) {
          if (state is DataFetchSuccessState) {
            // TODO: go to pin page or patient selection page depending on data fetch
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientTypeSelectionPage(),
                ));
          } else if (state is DataFetchFailureState) {
            print("Something went wrong");
          }
        },
        child: Column(
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
      ),
    );
  }
}
