import 'dart:convert';

class Patient {
  int id;
  String patientId;
  String patientName;
  double age;
  String sex;

  Patient({
    this.id,
    this.patientId,
    this.patientName,
    this.age,
    this.sex,
  });

  factory Patient.fromMap(Map<String, dynamic> json) => Patient(
    id: json["id"],
    patientId: json["patient_id"],
    patientName: json["patient_name"],
    age: json["age"],
    sex: json["sex"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "patient_id": patientId,
    "patient_name": patientName,
    "age": age,
    "sex": sex,
  };

  Patient patientFromJson(String str) {
    final jsonData = json.decode(str);
    return Patient.fromMap(jsonData);
  }

  String patientToJson(Patient patient) {
    final map = patient.toMap();
    return json.encode(map);
  }

  @override
  String toString() => "Patient: id: $id - patientId: $patientId - patientName: $patientName - age: $age - sex: $sex";
}
