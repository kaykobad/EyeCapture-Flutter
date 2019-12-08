import 'package:equatable/equatable.dart';

class SplashEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitiateDataFetchEvent extends SplashEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => "InitiateDataFetchEvent";
}