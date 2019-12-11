import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:torch/torch.dart';

class CameraPreview extends StatefulWidget {
  @override
  _CameraPreviewState createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<CameraPreview> {
  bool isFlashOn;
  bool hasFlashLight;

  @override
  void initState() {
    super.initState();
    isFlashOn = false;
    initLamp();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initLamp() async {
    hasFlashLight = await Torch.hasTorch;
    print("Has lamp: $hasFlashLight");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(IMAGE_PREVIEW_APPBAR),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _cameraPreviewWidget(),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                _captureControlRowWidget(context),
                _flashTogglesRowWidget(),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    return Container(
      margin: EdgeInsets.all(CAMERA_PADDING),
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
          border: Border.all(color: Colors.blueAccent)
      ),
    );
  }

  Widget _flashTogglesRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton.icon(
          onPressed: () {
            print("Flash mode switched");
            setState(() {
              isFlashOn = !isFlashOn;
            });
            if (hasFlashLight && isFlashOn) {
              Torch.turnOn();
            } else {
              Torch.turnOff();
            }
          },
          icon: isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
          label: isFlashOn ? Text("On") : Text("Off"),
        ),
      ),
    );
  }

  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              child: Icon(Icons.camera),
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                _onCapturePressed(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onCapturePressed(context) async {
    print("Capture Button Pressed");
  }
}
