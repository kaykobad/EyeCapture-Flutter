import 'dart:io';

import 'package:eye_capture/models/patient_model.dart';
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
}