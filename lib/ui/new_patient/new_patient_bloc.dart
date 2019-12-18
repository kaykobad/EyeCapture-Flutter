import 'package:bloc/bloc.dart';
import 'package:eye_capture/db/dbHelper.dart';
import 'package:eye_capture/models/appointment_model.dart';
import 'package:eye_capture/models/eye_model.dart';
import 'package:eye_capture/models/image_model.dart' as image;
import 'package:eye_capture/models/patient_model.dart';
import 'package:eye_capture/ui/new_patient/new_patient_event.dart';
import 'package:eye_capture/ui/new_patient/new_patient_state.dart';

class NewPatientBloc extends Bloc<NewPatientEvent, NewPatientSate> {
  String patientId;
  String patientName;
  String sex;
  double age;
  String dateTime;
  List<Eye> eyes = List<Eye>();
  bool isOldPatient = false;
  int oldPatientId = -1;

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

        int pId;
        if (!isOldPatient) {
          Patient patient = Patient(patientId: patientId, patientName: patientName, age: age, sex: sex);
          pId = await DBProvider.db.insertPatient(patient);
        } else {
          pId = oldPatientId;
        }

        Appointment appointment = Appointment(patientId: pId, dateTime: dateTime);
        int aId = await DBProvider.db.insertAppointment(appointment);

        for (Eye e in eyes) {
          image.Image img = image.Image(dateTime: e.dateTime, appointmentId: aId, eyeDescription: e.eyeDescription, imagePath: e.imagePath, zoomLevel: e.zoomLevel);
          int eId = await DBProvider.db.insertImage(img);
        }

        yield SavingPatientSuccessState();
      } on Exception catch (e) {
        yield SavingPatientFailedState();
      }
    }
  }

}