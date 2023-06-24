import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/utils/formatted_currency.dart';
import 'package:molopay/utils/responsive.dart';
import 'package:molopay/widgets/avatar.dart';

class CardTransaction extends StatelessWidget {
  final Transaction transaction;
  final bool withAvatar;
  final bool withName;

  const CardTransaction({
    super.key,
    required this.transaction,
    this.withAvatar = true,
    this.withName = true,
  });

  @override
  Widget build(BuildContext context) {
    final response = Responsive.of(context);
    return Container(
      width: double.infinity,
      height: response.dp(9),
      decoration: const BoxDecoration(
        // color: Color(0xff1B1B1B),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (withAvatar)
                Avatar(
                  name: transaction.name,
                  radius: response.dp(50),
                  urlImage: transaction.urlImage,
                ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (withName)
                    Text(
                      transaction.name,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700),
                    ),
                  const SizedBox(
                    height: 2,
                  ),
                  SizedBox(
                    width: 180,
                    child: Text(
                      transaction.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    DateFormat.yMMMMEEEEd()
                        .format(DateTime.parse(transaction.dateTransaction)),
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            width: 110,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                  '${transaction.type == 'GIVE' ? '+' : '-'} ${formattedCurrency(transaction.amount)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: transaction.type == 'GIVE'
                          ? Colors.greenAccent.shade400
                          : Colors.redAccent.shade400)),
            ),
          )
        ],
      ),
    );
  }
}
