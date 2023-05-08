import 'package:intl/intl.dart';

String formattedCurrency(double amount) {
  var formatter = NumberFormat.currency(
      locale: 'es_PE', symbol: 'S/. ', customPattern: '¤#,##0.00');

  String formattedAmount = formatter.format(amount);
  return formattedAmount;
}
