import 'package:equatable/equatable.dart';
import 'package:eye_capture/models/appointment_model.dart';
import 'package:eye_capture/models/image_model.dart';
import 'package:eye_capture/models/patient_model.dart';

class OldPatientSate extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class AllPatientsGetSuccessState extends OldPatientSate {
  final List<Patient> allPatients;

  AllPatientsGetSuccessState(this.allPatients);

  @override
  List<Object> get props => [allPatients];
}

class AllPatientsGetFailureState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class LoadingAllPatientGetState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class AllAppointmentsGetSuccessState extends OldPatientSate {
  final List<Appointment> allAppointments;

  AllAppointmentsGetSuccessState(this.allAppointments);

  @override
  List<Object> get props => [allAppointments];
}

class AllAppointmentsGetFailureState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class LoadingAllAppointmentsGetState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class AllImagesGetSuccessState extends OldPatientSate {
  final List<Image> images;

  AllImagesGetSuccessState(this.images);

  @override
  List<Object> get props => [images];
}

class AllImagesGetFailureState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class LoadingAllImagesGetState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class DeleteAppointmentSuccessState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class DeleteAppointmentFailureState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class LoadingDeleteAppointmentState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class DeletePatientSuccessState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class DeletePatientFailureState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class LoadingDeletePatientState extends OldPatientSate {
  @override
  List<Object> get props => [];
}