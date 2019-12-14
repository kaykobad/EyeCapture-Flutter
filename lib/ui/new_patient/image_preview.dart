import 'dart:io';

import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:flutter/material.dart';

class ImagePreviewWithButton extends StatefulWidget {
  final String imagePath;
  final String eyeDescription;
  final double zoomLevel;

  const ImagePreviewWithButton(
      {Key key, this.imagePath, this.eyeDescription, this.zoomLevel})
      : super(key: key);

  @override
  _ImagePreviewWithButtonState createState() => _ImagePreviewWithButtonState();
}

class _ImagePreviewWithButtonState extends State<ImagePreviewWithButton> {
  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: _imagePreview(),
              ),
              SizedBox(height: 10.0),
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
        _getSaveAndContinueButton(),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getDiscardButton(),
            SizedBox(width: 15.0),
            _getSaveButton(),
          ],
        ),
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
      onPressed: () => debugPrint("Discard button pressed"),
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
      onPressed: () => debugPrint("Save and continue button pressed"),
    );
  }

  Widget _imagePreview() {
    return RotatedBox(
      quarterTurns: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Image.file(
          File(widget.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
