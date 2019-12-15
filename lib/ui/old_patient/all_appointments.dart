import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/models/appointment_model.dart';
import 'package:eye_capture/models/patient_model.dart';
import 'package:eye_capture/ui/old_patient/old_patient_bloc.dart';
import 'package:eye_capture/ui/old_patient/old_patient_state.dart';
import 'package:eye_capture/ui/old_patient/old_patients_event.dart';
import 'package:eye_capture/ui/old_patient/view_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllAppointments extends StatefulWidget {
  final OldPatientBloc oldPatientBloc;
  final Patient patient;

  const AllAppointments({Key key, this.oldPatientBloc, this.patient})
      : super(key: key);

  @override
  _AllAppointmentsState createState() => _AllAppointmentsState();
}

class _AllAppointmentsState extends State<AllAppointments> {
  bool _isLoadingData;
  List<Appointment> allAppointments;
  int _selectedAppointment;

  @override
  void initState() {
    super.initState();
    widget.oldPatientBloc.add(GetAllAppointmentsEvent(widget.patient));
    _isLoadingData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.patient.patientName}",
        ),
      ),
      body: BlocListener(
        bloc: widget.oldPatientBloc,
        listener: (context, state) {
          if (state is AllAppointmentsGetSuccessState) {
            setState(() {
              allAppointments = state.allAppointments;
              _isLoadingData = false;
            });
          } else if (state is AllImagesGetSuccessState) {
            setState(() {
              _isLoadingData = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewReport(
                  oldPatientBloc: widget.oldPatientBloc,
                  patient: widget.patient,
                  appointment: allAppointments[_selectedAppointment],
                  images: state.images,
                ),
              ),
            );
          }
        },
        child: _isLoadingData
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 6.0,
                  semanticsLabel: "Loading appointment data...",
                ),
              )
            : Container(
                padding: EdgeInsets.all(PAGE_PADDING),
                child: _getAllAppointments(),
              ),
      ),
    );
  }

  Widget _getAllAppointments() {
    if (allAppointments.length == 0) {
      return Center(
        child: Text(
          "No appointment data found!",
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: allAppointments.length,
      itemBuilder: (context, idx) {
        return Card(
          child: ListTile(
            title: Text("Appointment: ${idx + 1}"),
            subtitle: Text(
                "Date: ${allAppointments[idx].dateTime.substring(0, 10)} - Time: ${allAppointments[idx].dateTime.substring(11, 19)}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDialog();
              },
            ),
            onTap: () {
              _selectedAppointment = idx;
              widget.oldPatientBloc
                  .add(GetAllImagesEvent(allAppointments[idx]));
            },
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
          title: Text(DELETE_APPOINTMENT_DIALOG_HEADER),
          content: Text(DELETE_APPOINTMENT_DIALOG_MESSAGE),
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
