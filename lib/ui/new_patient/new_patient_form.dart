import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/ui/new_patient/camera_preview.dart';
import 'package:flutter/material.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:intl/intl.dart';

class NewPatientForm extends StatefulWidget {
  @override
  _NewPatientFormState createState() => _NewPatientFormState();
}

class _NewPatientFormState extends State<NewPatientForm> {
  GlobalKey<FormState> _formKey;
  TextEditingController _patientIdController;
  TextEditingController _patientNameController;
  TextEditingController _patientAgeController;
  TextEditingController _dateTimeController;
  bool _autoValidate;
  String _radioValue;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _autoValidate = false;
    _radioValue = "Male";
    _patientIdController = TextEditingController();
    _patientNameController = TextEditingController();
    _patientAgeController = TextEditingController();
    var _currentDateTime = DateFormat.yMd().add_jm().format(DateTime.now());
    _dateTimeController = TextEditingController(text: _currentDateTime);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(NEW_PATIENT_APPBAR),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: _getFormUI(),
      ),
    );
  }

  Widget _getFormUI() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(PAGE_PADDING),
      child: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          _getPatientId(),
          SizedBox(height: 15.0),
          _getNameField(),
          SizedBox(height: 15.0),
          _getAgeField(),
          SizedBox(height: 15.0),
          _getRadioButtons(),
          SizedBox(height: 15.0),
          _getDateTimeField(),
          SizedBox(height: 20.0),
          _getTakePhotoButton(),
        ],
      ),
    );
  }

  TextFormField _getPatientId() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Patient ID",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 0.0),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _patientIdController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter a valid patient id";
        }
        return null;
      },
    );
  }

  TextFormField _getNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Patient Name",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 0.0),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _patientNameController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter a valid patient name";
        }
        return null;
      },
    );
  }

  TextFormField _getAgeField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Age",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 0.0),
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _patientAgeController,
      validator: (value) {
        RegExp ageExp = RegExp(r"^\d*\.?\d*$");
        if (!ageExp.hasMatch(value)) {
          return "Please enter a valid age";
        }
        return null;
      },
    );
  }

  TextFormField _getDateTimeField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Date and Time",
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 0.0),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _dateTimeController,
      enabled: false,
    );
  }

  void _onRadioButtonChanged(String value) {
    setState(() {
      _radioValue = value;
      print("$_radioValue");
    });
  }

  Widget _getRadioButtons() {
    return Row(
      children: <Widget>[
        Text(
          "Sex",
          style: TextStyle(
            fontSize: REGULAR_FONT_SIZE,
          ),
        ),
        Radio(
          value: "Male",
          groupValue: _radioValue,
          onChanged: _onRadioButtonChanged,
        ),
        Text(
          "Male",
          style: TextStyle(
            fontSize: REGULAR_FONT_SIZE,
          ),
        ),
        SizedBox(width: 15.0),
        Radio(
          value: "Female",
          groupValue: _radioValue,
          onChanged: _onRadioButtonChanged,
        ),
        Text(
          "Female",
          style: TextStyle(
            fontSize: REGULAR_FONT_SIZE,
          ),
        ),
      ],
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      String patientId = _patientIdController.text;
      String patientName = _patientNameController.text;
      int patientAge = int.tryParse(_patientAgeController.text);

      print("$patientId - $patientName - $patientAge");
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  RaisedButton _getTakePhotoButton() {
    return RaisedButton(
      child: Text(
        TAKE_PHOTO_BUTTON,
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
        print("Take photo pressed");
        _validateInputs();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LiveCameraPreview()));
      },
    );
  }
}
