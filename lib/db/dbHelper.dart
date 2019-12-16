import 'dart:io';

import 'package:eye_capture/models/appointment_model.dart';
import 'package:eye_capture/models/patient_model.dart';
import 'package:eye_capture/models/image_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "EyeCapture.db");
    return await openDatabase(path, version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
          // create Patient table
          await db.execute("CREATE TABLE Patient ("
              "id INTEGER PRIMARY KEY,"
              "patient_id TEXT,"
              "patient_name TEXT,"
              "age REAL,"
              "sex TEXT"
              ")"
          );

          // create Appointment table
          await db.execute("CREATE TABLE Appointment ("
              "id INTEGER PRIMARY KEY,"
              "patient_id INTEGER,"
              "date_time TEXT"
              ")"
          );

          // create Image table
          await db.execute("CREATE TABLE Image ("
              "id INTEGER PRIMARY KEY,"
              "appointment_id INTEGER,"
              "image_path TEXT,"
              "zoom_level REAL,"
              "eye_descripton TEXT,"
              "date_time TEXT"
              ")"
          );
        },
    );
  }


  // patient related functionality
  Future<int> insertPatient(Patient patient) async {
    final db = await database;
    return await db.insert("Patient", patient.toMap());
  }

  Future<int> deletePatientById(int id) async {
    final db = await database;
    return await db.delete("Patient", where: "id = ?", whereArgs: [id]);
  }

  Future<List<Patient>> getAllPatients() async {
    final db = await database;
    var res = await db.query("Patient");
    List<Patient> list = res.isNotEmpty ? res.map((c) => Patient.fromMap(c)).toList() : [];
    return list;
  }


  // appointment related functionality
  Future<int> insertAppointment(Appointment appointment) async {
    final db = await database;
    return await db.insert("Appointment", appointment.toMap());
  }

  Future<int> deleteAppointmentById(int id) async {
    final db = await database;
    return await db.delete("Appointment", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAppointmentsByPatientId(int patientId) async {
    final db = await database;
    return await db.delete("Appointment", where: "patient_id = ?", whereArgs: [patientId]);
  }

  Future<List<Appointment>> getAllAppointmentsByPatientId(int patientId) async {
    final db = await database;
    var res = await db.query("Appointment", where: "patient_id = ?", whereArgs: [patientId]);
    List<Appointment> list = res.isNotEmpty ? res.map((c) => Appointment.fromMap(c)).toList() : [];
    return list;
  }


  // image related functionality
  Future<int> insertImage(Image image) async {
    final db = await database;
    return await db.insert("Image", image.toMap());
  }

  Future<int> deleteImageById(int id) async {
    final db = await database;
    return await db.delete("Image", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteImagesByAppointmentId(int appointmentId) async {
    final db = await database;
    return await db.delete("Image", where: "appointment_id = ?", whereArgs: [appointmentId]);
  }

  Future<List<Image>> getAllImagesByAppointmentId(int appointmentId) async {
    final db = await database;
    var res = await db.query("Image", where: "appointment_id = ?", whereArgs: [appointmentId]);
    List<Image> list = res.isNotEmpty ? res.map((c) => Image.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> deletePatientData(int patientId) async {
    List<Appointment> appointments = await getAllAppointmentsByPatientId(patientId);
    for(Appointment a in appointments) {
      await deleteAppointmentData(a.id);
      await deleteAppointmentById(a.id);
    }
    return await deletePatientById(patientId);
  }

  Future<int> deleteAppointmentData(int appointmentId) async {
    List<Image> images = await getAllImagesByAppointmentId(appointmentId);
    for(Image e in images) {
      String imagePath = e.imagePath;
      File f = File(imagePath);
      await f.delete();
    }
    await deleteImagesByAppointmentId(appointmentId);
    return await deleteAppointmentById(appointmentId);
  }
}