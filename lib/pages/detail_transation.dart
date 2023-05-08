import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:molopay/utils/formatted_currency.dart';

import '../models/transaction.dart';

class DetailTransaction extends StatelessWidget {
  final Transaction transaction;

  const DetailTransaction({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Center(
          child: Column(
            children: [
              Text(
                formattedCurrency(transaction.amount),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                transaction.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Divider(),
              _RowTransaction(
                title: "Type transaction",
                description: transaction.type.toLowerCase(),
              ),
              _RowTransaction(
                title: "Date",
                description: DateFormat("dd/MM/yyyy")
                    .format(DateTime.parse(transaction.dateTransaction)),
              ),
              _RowTransaction(
                title: "Hour",
                description: DateFormat.jm()
                    .format(DateTime.parse(transaction.dateTransaction)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowTransaction extends StatelessWidget {
  final String title;
  final String description;

  const _RowTransaction({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Montserrat",
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                    fontFamily: "Montserrat", fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider()
      ],
    );
  }
}
