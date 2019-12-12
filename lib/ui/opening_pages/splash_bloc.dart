import 'package:bloc/bloc.dart';
import 'package:eye_capture/db/dbHelper.dart';
import 'package:eye_capture/models/patient_model.dart';
import 'package:eye_capture/ui/opening_pages/splash_event.dart';
import 'package:eye_capture/ui/opening_pages/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  @override
  SplashState get initialState => InitialState();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is InitiateDataFetchEvent) {
      yield LoadingDataFetchState();

      // data fetch will go here
//      Patient patient1 = Patient(patientName: "Kaykobad Reza", patientId: "kaykobad", age: 24, sex: "male");
//      DBProvider.db.insertPatient(patient1);
//      for(Patient p in await DBProvider.db.getAllPatients()) {
//        print(p.toString());
//      }
//      DBProvider.db.deletePatientById(1);
//      DBProvider.db.insertPatient(patient1);
//      for(Patient p in await DBProvider.db.getAllPatients()) {
//        print(p.toString());
//      }
//      DBProvider.db.deletePatientById(4);
//      DBProvider.db.insertPatient(patient1);
//      for(Patient p in await DBProvider.db.getAllPatients()) {
//        print(p.toString());
//      }
      await Future.delayed(Duration(seconds: 3));

      yield DataFetchSuccessState(false);
    }
  }

}