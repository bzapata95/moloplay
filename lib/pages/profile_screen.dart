import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:molopay/helpers/sql_helpers.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/utils/formatted_currency.dart';
import 'package:molopay/utils/formatted_transaction.dart';
import 'package:molopay/widgets/avatar.dart';
import 'package:molopay/widgets/card_transaction.dart';
import 'package:molopay/widgets/header.dart';

class ProfileScreen extends StatefulWidget {
  final Person person;
  const ProfileScreen({super.key, required this.person});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Transaction> transactions = [];

  onLoadTransactions() async {
    final response = await SQLHelper.getTransactionsByPersonId(
        id: widget.person.id, limit: 300);
    setState(() {
      transactions = formattedTransaction(response);
    });
  }

  @override
  void initState() {
    onLoadTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20)
            .copyWith(top: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Avatar(
                          name: widget.person.name,
                          radius: 150,
                          size: 80,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.person.name,
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Total debt",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          formattedCurrency(widget.person.balance!),
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Header(
                  title: "Transactions",
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        CardTransaction(transaction: transactions[index]),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  },
                  itemCount: transactions.length,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
