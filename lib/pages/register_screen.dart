import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/authentication/authentication_bloc.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/widgets/button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void handleSignUp(BuildContext context, String username) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Register your name.",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Only register in your device.",
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
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
                children: [
                  TextField(
                    controller: userNameController,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: 'Enter your username or name',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.3))),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Button(
                      onPressed: () {
                        handleSignUp(context, userNameController.text);
                      },
                      label: 'Sign Up',
                      colorButton: enumColorButton.white,
                    ),
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
