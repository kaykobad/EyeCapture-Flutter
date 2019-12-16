import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/ui/new_patient/new_patient_form.dart';
import 'package:eye_capture/ui/old_patient/all_old_patients.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PatientTypeSelectionPage extends StatefulWidget {
  @override
  _PatientTypeSelectionPageState createState() =>
      _PatientTypeSelectionPageState();
}

class _PatientTypeSelectionPageState extends State<PatientTypeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: WillPopScope(
        onWillPop: _closeAppDialog,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getPatientSelectionPrompt(),
              SizedBox(height: 15.0),
              _getOldPatientButton(),
              SizedBox(height: 10.0),
              _getNewPatientButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(PATIENT_SELECTION_PAGE_TITLE),
    );
  }

  Text _getPatientSelectionPrompt() {
    return Text(
      PATIENT_SELECTION_PROMPT,
      style: TextStyle(
        fontSize: TITLE_FONT_SIZE,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  RaisedButton _getNewPatientButton() {
    return RaisedButton(
      child: Text(
        NEW_PATIENT_BUTTON,
        style: TextStyle(
          color: Colors.white,
          fontSize: REGULAR_FONT_SIZE,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
          side: BorderSide(color: Colors.blueGrey)),
      padding: EdgeInsets.symmetric(
        horizontal: BUTTON_PADDING_LEFT,
        vertical: BUTTON_PADDING_TOP,
      ),
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NewPatientForm())),
    );
  }

  RaisedButton _getOldPatientButton() {
    return RaisedButton(
      child: Text(
        OLD_PATIENT_BUTTON,
        style: TextStyle(
          color: Colors.white,
          fontSize: REGULAR_FONT_SIZE,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BUTTON_BORDER_RADIUS),
          side: BorderSide(color: Colors.blueGrey)),
      padding: EdgeInsets.symmetric(
        horizontal: BUTTON_PADDING_LEFT,
        vertical: BUTTON_PADDING_TOP,
      ),
      onPressed: (() => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AllOldPatients()))),
    );
  }

  Future<bool> _closeAppDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit Application?'),
          content: Text('Do you really want to exit the application?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
      },
    );
  }
}
