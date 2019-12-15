import 'package:bloc/bloc.dart';
import 'package:eye_capture/db/dbHelper.dart';
import 'package:eye_capture/models/appointment_model.dart';
import 'package:eye_capture/models/patient_model.dart';
import 'package:eye_capture/models/image_model.dart' as image;
import 'package:eye_capture/ui/old_patient/old_patient_state.dart';
import 'package:eye_capture/ui/old_patient/old_patients_event.dart';
import 'package:flutter/cupertino.dart';

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
        debugPrint("Fetching all old patients...");

        List<Patient> allPatients = await DBProvider.db.getAllPatients();

        debugPrint("Patient fetch success!");
        yield AllPatientsGetSuccessState(allPatients);
      } on Exception catch (e) {
        debugPrint("Patient fetch failure!");
        yield AllPatientsGetFailureState();
      }
    }

    else if(event is GetAllAppointmentsEvent) {
      try {
        yield LoadingAllAppointmentsGetState();
        debugPrint("Fetching all appointments for patient id: ${event.patient.id}...");

        patient = event.patient;
        List<Appointment> allAppointments = await DBProvider.db.getAllAppointmentsByPatientId(patient.id);

        debugPrint("Appointments fetch success!");
        yield AllAppointmentsGetSuccessState(allAppointments);
      } on Exception catch (e) {
        debugPrint("Appointments fetch failure!");
        yield AllAppointmentsGetFailureState();
      }
    }

    else if(event is GetAllImagesEvent) {
      try {
        yield LoadingAllImagesGetState();
        debugPrint("Fetching all images for appointment id: ${event.appointment.id}...");

        appointment = event.appointment;
        images = await DBProvider.db.getAllImagesByAppointmentId(appointment.id);

        debugPrint("Images fetch success!");
        yield AllImagesGetSuccessState(images);
      } on Exception catch (e) {
        debugPrint("Images fetch failure!");
        yield AllImagesGetFailureState();
      }
    }

    else if(event is DeleteAppointmentEvent) {
      try {
        yield LoadingDeleteAppointmentState();
        debugPrint("Deleting appointment id: ${event.appointment.id}...");

        int numImageDeleted = await DBProvider.db.deleteImagesByAppointmentId(event.appointment.id);
        int numAppointmentDeleted = await DBProvider.db.deleteAppointmentById(event.appointment.id);

        debugPrint("Appointment delete success! Total img: $numImageDeleted, total appointment: $numAppointmentDeleted");
        yield DeleteAppointmentSuccessState();
      } on Exception catch (e) {
        debugPrint("Images fetch failure!");
        yield DeleteAppointmentFailureState();
      }
    }
  }

}