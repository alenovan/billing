part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class ActLogin extends AuthEvent {
  RequestLoginModels payload;

  ActLogin({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}
