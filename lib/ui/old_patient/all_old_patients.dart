import 'package:eye_capture/constants/numbers.dart';
import 'package:eye_capture/constants/strings.dart';
import 'package:eye_capture/models/patient_model.dart';
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
        title: Text(
          OLD_PATIENT_APPBAR,
        ),
      ),
      body: BlocListener(
        bloc: _oldPatientBloc,
        listener: (context, state) {
          if(state is AllPatientsGetSuccessState) {
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

  _getAllPatients() {
    return ListView.builder(
      itemCount: allPatients.length,
      itemBuilder: (context, idx) {
        return Card(
          child: ListTile(
            title: Text("${allPatients[idx].patientName}"),
            subtitle: Text("Sex: ${allPatients[idx].sex} - Age: ${allPatients[idx].age}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){},
            ),
          ),
        );
      },
    );
  }
}
