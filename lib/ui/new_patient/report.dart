import 'dart:io';

import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/models/eye_model.dart';
import 'package:eye_capture/ui/new_patient/new_patient_bloc.dart';
import 'package:eye_capture/ui/new_patient/new_patient_event.dart';
import 'package:eye_capture/ui/new_patient/new_patient_state.dart';
import 'package:eye_capture/ui/opening_pages/patient_selection_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as prefix1;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as prefix0;

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
  bool _isSaving;
  double width;

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

    _isSaving = false;
    print("${leftEyes.length}, ${rightEyes.length}");
  }

  @override
  void dispose() {
    super.dispose();
    //widget.newPatientBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width - (PAGE_PADDING * 4);

    return Scaffold(
      appBar: _getAppBar(),
      body: BlocListener(
        bloc: widget.newPatientBloc,
        listener: (context, state) {
          if (state is SavingPatientState) {
            setState(() {
              _isSaving = true;
            });
          } else if (state is SavingPatientSuccessState) {
            widget.newPatientBloc?.close();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientTypeSelectionPage()),
                (Route<dynamic> routes) => false);
          } else if (state is SavingPatientFailedState) {
            setState(() {
              _isSaving = false;
            });
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Saving failed, please try again"),
            ));
          }
        },
        child: SafeArea(
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
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(REPORT_APPBAR),
      automaticallyImplyLeading: false,
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
          onPressed: () => widget.newPatientBloc.add(SaveNewPatientEvent()),
        ),
      ],
    );
  }

  Container _getEyeImages() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: PAGE_PADDING),
      child: Column(
        children: <Widget>[
          leftEyes.length > 0 ? _leftEyePrompt() : Container(),
          SizedBox(height: 15.0),
          _getLeftEyeImages(),
          SizedBox(height: 15.0),
          rightEyes.length > 0 ? _rightEyePrompt() : Container(),
          SizedBox(height: 15.0),
          _getRightEyeImages(),
          SizedBox(height: 15.0),
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
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  debugPrint("Generating report...");
                  _generatePdf(context, leftEyes[idx].imagePath, eyes[0]);
                  debugPrint("Done Generating report...");
                },
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Container(
                    //margin: EdgeInsets.all(PAGE_PADDING),
                    height: width,
                    width: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(leftEyes[idx].imagePath)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
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
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  debugPrint("Generating report...");
                  _generatePdf(context, rightEyes[idx].imagePath, eyes[1]);
                  debugPrint("Done Generating report...");
                },
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Container(
                    height: width,
                    width: width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(rightEyes[idx].imagePath)),
                      ),
                    ),
                    //margin: EdgeInsets.all(PAGE_PADDING),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
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

  _generatePdf(context, imagePath, eyeDescription) async {
    final pdf = prefix0.Document();

    var img = decodeImage(File(imagePath).readAsBytesSync());
    int h = img.height;
    int w = img.width;
    int sqSize = h < w ? h : w;
    img = copyResizeCropSquare(img, sqSize);
    img = flip(img, Flip.both);
    final image = PdfImage(
      pdf.document,
      image: img.data.buffer.asUint8List(),
      width: img.width,
      height: img.height,
    );

    pdf.addPage(prefix0.MultiPage(
      build: (prefix0.Context context) => <prefix0.Widget>[
        prefix0.Header(
          level: 0,
          child: prefix0.Column(
            mainAxisAlignment: prefix0.MainAxisAlignment.center,
            children: <prefix0.Widget>[
              prefix0.Row(
                mainAxisAlignment: prefix0.MainAxisAlignment.spaceBetween,
                children: <prefix0.Widget>[
                  prefix0.Text(
                      "Patient Name: ${widget.newPatientBloc.patientName}",
                      textScaleFactor: 1.3),
                  prefix0.Text("ID: ${widget.newPatientBloc.patientId}",
                      textScaleFactor: 1.2),
                ],
              ),
              prefix0.SizedBox(height: 7),
              prefix0.Row(
                mainAxisAlignment: prefix0.MainAxisAlignment.spaceBetween,
                children: <prefix0.Widget>[
                  prefix0.Text("Sex: ${widget.newPatientBloc.sex}"),
                  prefix0.Text(
                      "Age: ${widget.newPatientBloc.age.toString()} years"),
                  prefix0.Text("Date: ${widget.newPatientBloc.dateTime.substring(0, 19)}"),
                ],
              ),
              prefix0.SizedBox(height: 10),
              prefix0.Text("$eyeDescription", textScaleFactor: 1.3),
            ],
          ),
        ),
        prefix0.Image(image),
      ],
    ));

    final path = prefix1.join((await getExternalStorageDirectory()).path,
        "${widget.newPatientBloc.patientName.replaceAll(" ", "_") + "_" + DateTime.now().toString().substring(0, 19).replaceAll(" ", "_")}.pdf");
    debugPrint("Saving file to path: $path");
    File f = File(path);
    f.writeAsBytesSync(pdf.save());
  }
}
