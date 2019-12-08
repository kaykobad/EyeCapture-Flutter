import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends SplashState {
  @override
  List<Object> get props => [];

  @override
  String toString() => "InitialState";
}

class LoadingDataFetchState extends SplashState {
  @override
  List<Object> get props => [];

  @override
  String toString() => "LoadingDataFetchState";
}

class DataFetchSuccessState extends SplashState {
  final bool isLoginRequired;

  DataFetchSuccessState(this.isLoginRequired);

  @override
  List<Object> get props => [isLoginRequired];

  @override
  String toString() => "DataFetchSuccessState";
}

class DataFetchFailureState extends SplashState {
  @override
  List<Object> get props => [];

  @override
  String toString() => "DataFetchFailureState";
}