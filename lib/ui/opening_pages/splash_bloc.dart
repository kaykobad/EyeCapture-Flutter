import 'package:bloc/bloc.dart';
import 'package:eye_capture/ui/opening_pages/splash_event.dart';
import 'package:eye_capture/ui/opening_pages/splash_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  @override
  SplashState get initialState => InitialState();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is InitiateDataFetchEvent) {
      try {
        yield LoadingDataFetchState();

        // show splash screen
        await Future.delayed(Duration(seconds: 2));

        // check if first time login
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isFirstTime = prefs.getBool("isFirstTime");

        if(isFirstTime == null) {
          yield DataFetchSuccessState(true);
        } else {
          yield DataFetchSuccessState(false);
        }

      } on Exception catch (e) {
        yield DataFetchFailureState();
      }
    }
  }

}