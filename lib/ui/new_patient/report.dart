import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/ui/new_patient/new_patient_bloc.dart';
import 'package:flutter/material.dart';

class ReportPreview extends StatefulWidget {
  final NewPatientBloc newPatientBloc;

  const ReportPreview({Key key, this.newPatientBloc}) : super(key: key);

  @override
  _ReportPreviewState createState() => _ReportPreviewState();
}

class _ReportPreviewState extends State<ReportPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(REPORT_APPBAR),
      actions: <Widget>[
        FlatButton.icon(
          textColor: Colors.white,
          icon: Icon(Icons.save),
          label: Text(
            SAVE_DATA,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          onPressed: (){},
        ),
      ],
    );
  }
}
