import 'package:flutter/material.dart';
import 'package:molopay/helpers/sql_helpers.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/utils/formatted_transaction.dart';
import 'package:molopay/widgets/card_transaction.dart';

class AllTransactionScreen extends StatefulWidget {
  const AllTransactionScreen({super.key});

  @override
  State<AllTransactionScreen> createState() => _AllTransactionScreenState();
}

class _AllTransactionScreenState extends State<AllTransactionScreen> {
  List<Transaction> transactions = [];

  Future<void> onLoadTransactions() async {
    final transactionsSql = await SQLHelper.getTransactions(limit: 500);
    transactions = formattedTransaction(transactionsSql);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onLoadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Transaction")),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          itemBuilder: (_, index) {
            final transaction = transactions[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.detailsTransaction,
                        arguments: transaction);
                  },
                  child: CardTransaction(transaction: transaction),
                ),
                const Divider()
              ],
            );
          },
          itemCount: transactions.length),
    );
  }
}
