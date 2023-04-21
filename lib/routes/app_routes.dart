import 'package:flutter/material.dart';
import 'package:molopay/pages/dashboard.dart';
import 'package:molopay/pages/register_screen.dart';
import 'package:molopay/pages/register_transaction.dart';
import 'package:molopay/routes/routes.dart';

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.dashboard: (_) => const Dashboard(),
    Routes.registerTransaction: (_) => const RegisterTransaction(),
    Routes.authenticationScreen: (_) => const RegisterScreen(),
  };
}
