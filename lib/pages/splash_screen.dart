import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialization();
    });
  }

  Future<void> initialization() async {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final isAuth = await authenticationBloc.verifyAuthenticationUser();

    if (mounted) {
      if (isAuth == false) {
        Navigator.pushReplacementNamed(context, Routes.authenticationScreen);
      } else {
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      }
    }
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
