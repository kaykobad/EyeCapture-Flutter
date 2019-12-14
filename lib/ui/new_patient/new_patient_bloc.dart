import 'package:bloc/bloc.dart';
import 'package:eye_capture/models/eye_model.dart';
import 'package:eye_capture/ui/new_patient/new_patient_event.dart';
import 'package:eye_capture/ui/new_patient/new_patient_state.dart';
import 'package:flutter/cupertino.dart';

class NewPatientBloc extends Bloc<NewPatientEvent, NewPatientSate> {
  String patientId;
  String patientName;
  String sex;
  double age;
  String dateTime;
  List<Eye> eyes;

  @override
  NewPatientSate get initialState => InitialState();

  @override
  Stream<NewPatientSate> mapEventToState(NewPatientEvent event) async* {
    if(event is SaveNewPatientInfoEvent) {
      patientId = event.patientId;
      patientName = event.patientName;
      sex = event.sex;
      age = event.age;
      dateTime = event.dateTime;

      yield ContinueState();
    }
  }

}