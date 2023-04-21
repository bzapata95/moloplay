part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final bool isAuthenticated;
  final String username;

  const AuthenticationState({
    this.isAuthenticated = false,
    this.username = "",
  });

  AuthenticationState copyWith({
    bool? isAuthenticated,
    String? username,
  }) =>
      AuthenticationState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        username: username ?? this.username,
      );

  @override
  List<Object> get props => [
        isAuthenticated,
        username,
      ];

  @override
  String toString() =>
      '{ isAuthenticated: $isAuthenticated, username: $username }';
}
