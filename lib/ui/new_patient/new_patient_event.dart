import 'package:equatable/equatable.dart';

class NewPatientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveNewPatientEvent extends NewPatientEvent {
  @override
  List<Object> get props => [];
}

class SaveNewPatientInfoEvent extends NewPatientEvent {
  final String patientName;
  final String patientId;
  final double age;
  final String sex;
  final String dateTime;

  SaveNewPatientInfoEvent(this.patientName, this.patientId, this.age, this.sex, this.dateTime);

  @override
  List<Object> get props => [patientId, patientName, age, sex, dateTime];
}

class SaveNewPatientEyeEvent extends NewPatientEvent {
  final String imagePath;
  final String dateTime;
  final String eyeDescription;
  final double zoomLevel;

  SaveNewPatientEyeEvent(this.imagePath, this.dateTime, this.zoomLevel, this.eyeDescription);

  @override
  List<Object> get props => [imagePath, dateTime, eyeDescription, zoomLevel];
}