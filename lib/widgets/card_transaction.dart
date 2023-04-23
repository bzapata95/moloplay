import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/widgets/avatar.dart';

class CardTransaction extends StatelessWidget {
  final Transaction transaction;

  const CardTransaction({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xff1B1B1B),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Avatar(
                name: transaction.name,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.name),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd().format(transaction.createdAt),
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          Text(
              '${transaction.type == 'GIVE' ? '+' : '-'} S/ ${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: transaction.type == 'GIVE'
                      ? Colors.greenAccent.shade400
                      : Colors.redAccent.shade400))
        ]),
      ),
    );
  }
}
