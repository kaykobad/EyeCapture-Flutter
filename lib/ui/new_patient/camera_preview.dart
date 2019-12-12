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
  List<String> eyes = [LEFT_EYE, RIGHT_EYE];
  int eyeSelector;
  double scale;

  @override
  void initState() {
    super.initState();
    isFlashOn = false;
    scale = 1.0;
    eyeSelector = 0;
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
                _eyeToggleRowWidget(),
                _captureControlRowWidget(context),
                _flashToggleRowWidget(),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    return Column(
      children: <Widget>[
        _getSliderController(),
        Container(
          margin: EdgeInsets.all(CAMERA_PADDING),
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent),
          ),
          child: Transform.scale(
            scale: scale,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                color: Colors.black45,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _getSliderController() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Slider(
            activeColor: Colors.blue,
            min: 1.0,
            max: 3.0,
            divisions: 20,
            value: scale,
            onChanged: (value) {
              setState(() {
                scale = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 20.0),
          child: Text("${double.parse(scale.toStringAsFixed(2))} X"),
        ),
      ],
    );
  }

  Widget _flashToggleRowWidget() {
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

  Widget _eyeToggleRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
          onPressed: () {
            print("Eye mode switched");
            setState(() {
              eyeSelector = (eyeSelector + 1) % 2;
            });
          },
          icon: Icon(Icons.remove_red_eye),
          label: Text(eyes[eyeSelector]),
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
