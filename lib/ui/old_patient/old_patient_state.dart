import 'package:equatable/equatable.dart';
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
  List<Object> get props => [];
}

class AllPatientsGetFailureState extends OldPatientSate {
  @override
  List<Object> get props => [];
}

class LoadingAllPatientGetState extends OldPatientSate {
  @override
  List<Object> get props => [];
}