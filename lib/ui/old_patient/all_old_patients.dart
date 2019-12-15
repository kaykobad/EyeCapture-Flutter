import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/models/patient_model.dart';
import 'package:eye_capture/ui/old_patient/all_appointments.dart';
import 'package:eye_capture/ui/old_patient/old_patient_bloc.dart';
import 'package:eye_capture/ui/old_patient/old_patient_state.dart';
import 'package:eye_capture/ui/old_patient/old_patients_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllOldPatients extends StatefulWidget {
  @override
  _AllOldPatientsState createState() => _AllOldPatientsState();
}

class _AllOldPatientsState extends State<AllOldPatients> {
  OldPatientBloc _oldPatientBloc;
  bool _isLoadingData;
  List<Patient> allPatients;

  @override
  void initState() {
    super.initState();
    _oldPatientBloc = OldPatientBloc();
    _oldPatientBloc.add(GetAllOldPatientsEvent());
    _isLoadingData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          OLD_PATIENT_APPBAR,
        ),
      ),
      body: BlocListener(
        bloc: _oldPatientBloc,
        listener: (context, state) {
          if (state is AllPatientsGetSuccessState) {
            setState(() {
              allPatients = state.allPatients;
              _isLoadingData = false;
            });
          }
        },
        child: _isLoadingData
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                  semanticsLabel: "Loading patient data...",
                ),
              )
            : Container(
                padding: EdgeInsets.all(PAGE_PADDING),
                child: _getAllPatients(),
              ),
      ),
    );
  }

  Widget _getAllPatients() {
    if (allPatients.length == 0) {
      return Center(
        child: Text(
          "No patient data found!",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: allPatients.length,
      itemBuilder: (context, idx) {
        return Card(
          child: ListTile(
            title: Text("${allPatients[idx].patientName}"),
            subtitle: Text(
                "Sex: ${allPatients[idx].sex} - Age: ${allPatients[idx].age}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDialog();
              },
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllAppointments(
                  patient: allPatients[idx],
                  oldPatientBloc: _oldPatientBloc,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DELETE_PATIENT_DIALOG_HEADER),
          content: Text(DELETE_PATIENT_DIALOG_MESSAGE),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "No",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
