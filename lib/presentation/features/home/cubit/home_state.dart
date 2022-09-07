import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends HomeState {}

class LoadingState extends HomeState {}

class SuccessState extends HomeState {}

class FailureState extends HomeState {
  final String message;

  FailureState(this.message);

  @override
  List<Object> get props => [message];
}
