import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:molopay/blocs/authentication/authentication_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/routes/app_routes.dart';
import 'package:molopay/routes/routes.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthenticationBloc(),
      ),
      BlocProvider(
        create: (context) => BusinessBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final String initialRoute;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    final isAuth = await authenticationBloc.verifyAuthenticationUser();

    if (isAuth == false) {
      initialRoute = Routes.authenticationScreen;
    } else {
      initialRoute = Routes.dashboard;
    }
    setState(() {});
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xff0F0F0F),
          hintColor: const Color(0xffF8FBFA)),
      routes: appRoutes,
      initialRoute: initialRoute,
    );
  }
}
