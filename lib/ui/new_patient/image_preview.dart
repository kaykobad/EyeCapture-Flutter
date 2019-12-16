import 'dart:io';

import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/ui/new_patient/new_patient_bloc.dart';
import 'package:eye_capture/ui/new_patient/new_patient_event.dart';
import 'package:eye_capture/ui/new_patient/report.dart';
import 'package:flutter/material.dart';

class ImagePreviewWithButton extends StatefulWidget {
  final NewPatientBloc newPatientBloc;
  final String imagePath;
  final String dateTime;
  final String eyeDescription;
  final double zoomLevel;

  const ImagePreviewWithButton(
      {Key key,
      this.imagePath,
      this.dateTime,
      this.eyeDescription,
      this.zoomLevel,
      this.newPatientBloc})
      : super(key: key);

  @override
  _ImagePreviewWithButtonState createState() => _ImagePreviewWithButtonState();
}

class _ImagePreviewWithButtonState extends State<ImagePreviewWithButton> {
  double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width - (PAGE_PADDING*2);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(IMAGE_PREVIEW_APPBAR),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(PAGE_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getEyeDescription(),
              SizedBox(height: 10.0),
              Center(
                child: _imagePreview(),
              ),
              SizedBox(height: 25.0),
              _getControllerButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Text _getEyeDescription() {
    return Text(
      "${widget.eyeDescription}",
      style: TextStyle(
        color: Colors.blueGrey,
        fontWeight: FontWeight.w600,
        fontSize: TITLE_FONT_SIZE,
      ),
    );
  }

  Column _getControllerButtons() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getDiscardButton(),
            SizedBox(width: 15.0),
            _getSaveButton(),
          ],
        ),
        SizedBox(height: 10.0),
        _getSaveAndContinueButton(),
      ],
    );
  }

  RaisedButton _getDiscardButton() {
    return RaisedButton(
      color: Colors.red,
      child: Text(
        DISCARD_BUTTON,
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
        debugPrint("Discard button pressed");
        File f = File(widget.imagePath);
        var isDeleted = f.delete();
        debugPrint(isDeleted.toString());
        Navigator.of(context).pop();
      },
    );
  }

  RaisedButton _getSaveButton() {
    return RaisedButton(
      child: Text(
        DONE_BUTTON,
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
        debugPrint("Save button pressed");
        widget.newPatientBloc.add(SaveNewPatientEyeEvent(
          widget.imagePath,
          widget.dateTime,
          widget.zoomLevel,
          widget.eyeDescription,
        ));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ReportPreview(newPatientBloc: widget.newPatientBloc,),
        ));
      },
    );
  }

  RaisedButton _getSaveAndContinueButton() {
    return RaisedButton(
      child: Text(
        SAVE_AND_TAKE_ANOTHER,
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
        debugPrint("Save and continue button pressed");
        widget.newPatientBloc.add(SaveNewPatientEyeEvent(
          widget.imagePath,
          widget.dateTime,
          widget.zoomLevel,
          widget.eyeDescription,
        ));
        Navigator.of(context).pop();
      },
    );
  }

  Widget _imagePreview() {
    return RotatedBox(
      quarterTurns: 2,
      child: Container(
        height: width,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(File(widget.imagePath)),
          ),
        ),
      ),
    );
  }
}
