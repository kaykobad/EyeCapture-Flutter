import 'package:bloc/bloc.dart';
import 'package:eye_capture/db/dbHelper.dart';
import 'package:eye_capture/models/appointment_model.dart';
import 'package:eye_capture/models/eye_model.dart';
import 'package:eye_capture/models/image_model.dart' as image;
import 'package:eye_capture/models/patient_model.dart';
import 'package:eye_capture/ui/new_patient/new_patient_event.dart';
import 'package:eye_capture/ui/new_patient/new_patient_state.dart';
import 'package:flutter/cupertino.dart';

class NewPatientBloc extends Bloc<NewPatientEvent, NewPatientSate> {
  String patientId;
  String patientName;
  String sex;
  double age;
  String dateTime;
  List<Eye> eyes = List<Eye>();

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

    else if(event is SaveNewPatientEyeEvent) {
      Eye eye = Eye(
        event.imagePath,
        event.eyeDescription,
        event.dateTime,
        event.zoomLevel,
      );

      eyes.add(eye);
      yield ContinueState();
    }

    else if(event is SaveNewPatientEvent) {
      try {
        yield SavingPatientState();

        debugPrint("Saving patient...");
        Patient patient = Patient(patientId: patientId, patientName: patientName, age: age, sex: sex);
        int pId = await DBProvider.db.insertPatient(patient);
        debugPrint("Saving patient done with id: $pId");

        debugPrint("Saving appointment...");
        Appointment appointment = Appointment(patientId: pId, dateTime: dateTime);
        int aId = await DBProvider.db.insertAppointment(appointment);
        debugPrint("Saving appointment done with id: $aId");

        debugPrint("Saving images...");
        for (Eye e in eyes) {
          image.Image img = image.Image(dateTime: e.dateTime, appointmentId: aId, eyeDescription: e.eyeDescription, imagePath: e.imagePath, zoomLevel: e.zoomLevel);
          int eId = await DBProvider.db.insertImage(img);
          debugPrint("Saving image done with id: $eId");
        }
        debugPrint("Saving done!");

        yield SavingPatientSuccessState();
      } on Exception catch (e) {
        debugPrint("Saving failed, something went wrong: $e!");
        yield SavingPatientFailedState();
      }
    }
  }

}