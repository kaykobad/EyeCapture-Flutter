import 'dart:convert';

class Appointment {
  int id;
  int patientId;
  String dateTime;

  Appointment({
    this.id,
    this.patientId,
    this.dateTime,
  });

  factory Appointment.fromMap(Map<String, dynamic> json) => Appointment(
    id: json["id"],
    patientId: json["patient_id"],
    dateTime: json["date_time"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "patient_id": patientId,
    "date_time": dateTime,
  };

  Appointment appointmentFromJson(String str) {
    final jsonData = json.decode(str);
    return Appointment.fromMap(jsonData);
  }

  String appointmentToJson(Appointment appointment) {
    final map = appointment.toMap();
    return json.encode(map);
  }
}
