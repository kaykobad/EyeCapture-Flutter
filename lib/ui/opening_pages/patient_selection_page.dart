import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:flutter/material.dart';

class PatientTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Center(
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
        side: BorderSide(color: Colors.blueGrey)
      ),
      padding: EdgeInsets.symmetric(horizontal: BUTTON_PADDING_LEFT, vertical: BUTTON_PADDING_TOP,),
      onPressed: () => print("New patient pressed"),
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
        side: BorderSide(color: Colors.blueGrey)
      ),
      padding: EdgeInsets.symmetric(horizontal: BUTTON_PADDING_LEFT, vertical: BUTTON_PADDING_TOP,),
      onPressed: () => print("Old patient pressed"),
    );
  }
}