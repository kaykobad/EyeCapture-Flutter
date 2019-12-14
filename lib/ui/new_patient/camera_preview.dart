import 'package:camera/camera.dart';
import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:torch/torch.dart';

class LiveCameraPreview extends StatefulWidget {
  @override
  _LiveCameraPreviewState createState() => _LiveCameraPreviewState();
}

class _LiveCameraPreviewState extends State<LiveCameraPreview> {
  bool isFlashOn;
  bool hasFlashLight;
  List<String> eyes = [LEFT_EYE, RIGHT_EYE];
  int eyeSelector;
  double scale;
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

  @override
  void initState() {
    super.initState();
    isFlashOn = false;
    scale = 1.0;
    eyeSelector = 0;
    initCamera();
    //initLamp();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  initCamera() {
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
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
            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                _getSliderController(),
                SizedBox(height: 10.0),
                _getCaptureImageRow(context),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Row _getCaptureImageRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _eyeToggleRowWidget(),
        _captureControlRowWidget(context),
        //_flashToggleRowWidget(),
        Spacer(),
      ],
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return Transform.scale(
      scale: scale,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: RotatedBox(
          quarterTurns: 2,
          child: CameraPreview(controller),
        ),
      ),
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
    try {
      final path = join(
        (await getExternalStorageDirectory()).path,
        '${DateTime.now().toString().replaceAll(" ", "_").substring(0, 19)}.png',
      );
      debugPrint(path);
      await controller.takePicture(path);
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => PreviewImageScreen(imagePath: path),
//        ),
//      );
    } catch (e) {
      print(e);
    }
  }
}
