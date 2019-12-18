import 'package:bloc/bloc.dart';
import 'package:eye_capture/db/dbHelper.dart';
import 'package:eye_capture/models/appointment_model.dart';
import 'package:eye_capture/models/patient_model.dart';
import 'package:eye_capture/models/image_model.dart' as image;
import 'package:eye_capture/ui/old_patient/old_patient_state.dart';
import 'package:eye_capture/ui/old_patient/old_patients_event.dart';

class OldPatientBloc extends Bloc<OldPatientEvent, OldPatientSate> {
  Patient patient;
  Appointment appointment;
  List<image.Image> images;

  @override
  OldPatientSate get initialState => InitialState();

  @override
  Stream<OldPatientSate> mapEventToState(OldPatientEvent event) async* {
    if(event is GetAllOldPatientsEvent) {
      try {
        yield LoadingAllPatientGetState();
        List<Patient> allPatients = await DBProvider.db.getAllPatients();
        yield AllPatientsGetSuccessState(allPatients);
      } on Exception catch (e) {
        yield AllPatientsGetFailureState();
      }
    }

    else if(event is GetAllAppointmentsEvent) {
      try {
        yield LoadingAllAppointmentsGetState();
        patient = event.patient;
        List<Appointment> allAppointments = await DBProvider.db.getAllAppointmentsByPatientId(patient.id);
        yield AllAppointmentsGetSuccessState(allAppointments);
      } on Exception catch (e) {
        yield AllAppointmentsGetFailureState();
      }
    }

    else if(event is GetAllImagesEvent) {
      try {
        yield LoadingAllImagesGetState();
        appointment = event.appointment;
        images = await DBProvider.db.getAllImagesByAppointmentId(appointment.id);
        yield AllImagesGetSuccessState(images);
      } on Exception catch (e) {
        yield AllImagesGetFailureState();
      }
    }

    else if(event is DeleteAppointmentEvent) {
      try {
        yield LoadingDeleteAppointmentState();
        int num = await DBProvider.db.deleteAppointmentData(event.appointment.id);
        yield DeleteAppointmentSuccessState();
      } on Exception catch (e) {
        yield DeleteAppointmentFailureState();
      }
    }

    else if(event is DeletePatientEvent) {
      try {
        yield LoadingDeletePatientState();
        int deletedPatient = await DBProvider.db.deletePatientData(event.patient.id);
        yield DeletePatientSuccessState();
      } on Exception catch (e) {
        yield DeletePatientFailureState();
      }
    }
  }

}