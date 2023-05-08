import 'package:flutter/material.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/pages/all_transaction_screen.dart';
import 'package:molopay/pages/dashboard.dart';
import 'package:molopay/pages/detail_transation.dart';
import 'package:molopay/pages/register_screen.dart';
import 'package:molopay/pages/register_transaction.dart';
import 'package:molopay/routes/routes.dart';

T getArguments<T>(BuildContext context) {
  return ModalRoute.of(context)!.settings.arguments as T;
}

Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.dashboard: (_) => const Dashboard(),
    Routes.registerTransaction: (_) => const RegisterTransaction(),
    Routes.authenticationScreen: (_) => const RegisterScreen(),
    Routes.allTransaction: (_) => const AllTransactionScreen(),
    Routes.detailsTransaction: (context) {
      final transaction = getArguments<Transaction>(context);
      return DetailTransaction(
        transaction: transaction,
      );
    },
  };
}
