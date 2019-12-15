import 'dart:io';

import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/models/eye_model.dart';
import 'package:eye_capture/ui/new_patient/new_patient_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportPreview extends StatefulWidget {
  final NewPatientBloc newPatientBloc;

  const ReportPreview({Key key, this.newPatientBloc}) : super(key: key);

  @override
  _ReportPreviewState createState() => _ReportPreviewState();
}

class _ReportPreviewState extends State<ReportPreview> {
  List<String> eyes = [LEFT_EYE, RIGHT_EYE];
  List<Eye> leftEyes = List<Eye>();
  List<Eye> rightEyes = List<Eye>();

  @override
  void initState() {
    super.initState();
    for (Eye e in widget.newPatientBloc.eyes) {
      if (e.eyeDescription == eyes[0]) {
        leftEyes.add(e);
      } else {
        rightEyes.add(e);
      }
    }

    print("${leftEyes.length}, ${rightEyes.length}");
  }

  @override
  void dispose() {
    super.dispose();
    widget.newPatientBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(PAGE_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getPatientDescription(),
                SizedBox(height: 20.0),
                _getEyeImages(),
              ],
            ),
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
          onPressed: () {},
        ),
      ],
    );
  }

  Container _getEyeImages() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: PAGE_PADDING),
      child: Column (
        children: <Widget>[
          leftEyes.length > 0 ? _leftEyePrompt() : Container(),
          _getLeftEyeImages(),
          rightEyes.length > 0 ? _rightEyePrompt() : Container(),
          _getRightEyeImages(),
        ],
      ),
    );
  }

  Column _getPatientDescription() {
    return Column(
      children: <Widget>[
        Text(
          "Name: ${widget.newPatientBloc.patientName}",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: TITLE_FONT_SIZE,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Age: ${widget.newPatientBloc.age} years",
              style: TextStyle(
                fontSize: REGULAR_FONT_SIZE,
              ),
            ),
            Text(
              "Sex: ${widget.newPatientBloc.sex}",
              style: TextStyle(
                fontSize: REGULAR_FONT_SIZE,
              ),
            ),
            Text(
              "Date: ${widget.newPatientBloc.dateTime.substring(0, 10)}",
              style: TextStyle(
                fontSize: REGULAR_FONT_SIZE,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getLeftEyeImages() {
    if (leftEyes.length > 0) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: leftEyes.length,
        itemBuilder: (BuildContext context, int idx) {
          return Container(
            margin: EdgeInsets.all(PAGE_PADDING),
            height: 250,
            width: 250,
            child: Image.file(
              File(leftEyes[idx].imagePath),
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }

    return Container();
  }

  Text _leftEyePrompt() {
    return Text(
      LEFT_EYE,
      style: TextStyle(
        fontSize: TITLE_FONT_SIZE,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _getRightEyeImages() {
    if (rightEyes.length > 0) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: rightEyes.length,
        itemBuilder: (BuildContext context, int idx) {
          return Container(
            height: 250,
            width: 250,
            margin: EdgeInsets.all(PAGE_PADDING),
            child: Image.file(
              File(rightEyes[idx].imagePath),
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }

    return Container();
  }

  Text _rightEyePrompt() {
    return Text(
      RIGHT_EYE,
      style: TextStyle(
        fontSize: TITLE_FONT_SIZE,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
