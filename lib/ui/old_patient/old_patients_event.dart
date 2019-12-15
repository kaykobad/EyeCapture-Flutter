import 'package:equatable/equatable.dart';
import 'package:eye_capture/models/patient_model.dart';

class OldPatientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAllOldPatientsEvent extends OldPatientEvent {
  @override
  List<Object> get props => [];
}

class GetAllAppointmentsEvent extends OldPatientEvent {
  final Patient patient;

  GetAllAppointmentsEvent(this.patient);

  @override
  List<Object> get props => [patient];
}
