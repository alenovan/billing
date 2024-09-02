part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AuthLoadingState extends AuthState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AuthLoadedState extends AuthState {
  ResponseLoginModels result;

  AuthLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class AuthErrorState extends AuthState {
  String message;

  AuthErrorState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

