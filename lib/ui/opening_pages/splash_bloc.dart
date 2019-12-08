import 'package:bloc/bloc.dart';
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
      await Future.delayed(Duration(seconds: 3));

      yield DataFetchSuccessState(false);
    }
  }

}