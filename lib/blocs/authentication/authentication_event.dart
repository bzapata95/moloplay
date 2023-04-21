part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends AuthenticationEvent {
  final String username;

  const RegisterUserEvent(this.username);
}
