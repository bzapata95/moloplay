import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/authentication/authentication_bloc.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/widgets/button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void handleSignUp(BuildContext context, String username) {
    if (username.trim().isEmpty) {
      return;
    }
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    authBloc.add(RegisterUserEvent(username));

    Navigator.pushReplacementNamed(context, Routes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final userNameController = TextEditingController();

    return Scaffold(
        body: Column(
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Register your name.",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Only register in your device.",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Color(0xff1B1B1B),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    controller: userNameController,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Enter your username or name',
                      hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white.withOpacity(0.3)),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      handleSignUp(context, value);
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Button(
                          onPressed: () {
                            handleSignUp(context, userNameController.text);
                          },
                          label: 'Sign Up',
                          colorButton: enumColorButton.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
