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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final focus = FocusScope.of(context);
        final focusChild = focus.focusedChild;
        if (focusChild != null && !focusChild.hasPrimaryFocus) {
          focusChild.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xff0F0F0F),
          hintColor: const Color(0xffF8FBFA),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xff1B1B1B)),
          dividerColor: Colors.grey.withOpacity(0.5),
        ),
        routes: appRoutes,
        initialRoute: Routes.splash,
      ),
    );
  }
}
