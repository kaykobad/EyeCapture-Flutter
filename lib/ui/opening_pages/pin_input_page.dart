import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/ui/opening_pages/patient_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinInputPage extends StatefulWidget {
  @override
  _PinInputPageState createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  TextEditingController _pinInputController;
  GlobalKey<FormState> _formKey;
  bool _hasError;

  @override
  void initState() {
    super.initState();
    _pinInputController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _hasError = false;
  }

  @override
  void dispose() {
    super.dispose();
    _pinInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(PAGE_PADDING),
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  PIN_INPUT_PROMPT,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                    fontSize: TITLE_FONT_SIZE,
                  ),
                ),
                SizedBox(height: 15.0),
                _getPinField(),
                SizedBox(height: 10.0),
                _hasError ? _errorPrompt() : Container(),
                SizedBox(height: 15.0),
                _getSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _getPinField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: "PIN",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 0.0),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _pinInputController,
      validator: (value) {
        RegExp ageExp = RegExp(r"^[A-Za-z0-9_]*$");
        if (!ageExp.hasMatch(value)) {
          return "Please enter a valid pin";
        }
        return null;
      },
    );
  }

  void _validateInputs() async {
    if (_formKey.currentState.validate()) {
      String pin = _pinInputController.text;
      print("$pin");

      if (pin == "amslergrid789108") {
        // set that login is not required
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isFirstTime", false);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PatientTypeSelectionPage(),
          ),
        );
      }
      else {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  RaisedButton _getSubmitButton() {
    return RaisedButton(
      child: Text(
        SUBMIT_BUTTON,
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
      onPressed: () {
        print("Submit pressed");
        _validateInputs();
      },
    );
  }

  Text _errorPrompt() {
    return Text(
      "Invaid PIN. Please enter a valid PIN.",
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }
}
