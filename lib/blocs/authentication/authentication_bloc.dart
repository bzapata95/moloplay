import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(const AuthenticationState()) {
    on<RegisterUserEvent>((event, emit) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final username = event.username;

      pref.setString("username", username);
      emit(state.copyWith(
        isAuthenticated: true,
        username: username,
      ));
    });
  }

  Future<bool> verifyAuthenticationUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final username = pref.getString("username");
    if (username != null) {
      add(RegisterUserEvent(username));
      return true;
    }
    return false;
  }
}
