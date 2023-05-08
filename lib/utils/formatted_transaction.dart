import 'package:molopay/models/transaction.dart';

List<Transaction> formattedTransaction(
    List<Map<String, dynamic>> transactions) {
  final formattedTransactions = transactions
      .map((e) => Transaction(
            amount: double.parse(e['amount'].toString()),
            createdAt: DateTime.parse(e['createAt']),
            id: e['id'],
            name: e['name'],
            type: e['type'] != null ? e['type'].toString() : "",
            description: e['description'],
            dateTransaction: e['dateTransaction'],
          ))
      .toList();
  return formattedTransactions;
}
