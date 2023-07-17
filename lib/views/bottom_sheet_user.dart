import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/models/person.dart';

import '../app/presentation/global/colors.dart';
import '../blocs/business/business_bloc.dart';
import '../models/transaction.dart';
import '../routes/routes.dart';
import '../utils/formatted_currency.dart';
import '../widgets/avatar.dart';
import '../widgets/button.dart';

class BottomSheerUser extends StatelessWidget {
  const BottomSheerUser({
    super.key,
    required this.person,
  });
  final Person person;

  @override
  Widget build(BuildContext context) {
    final businessBloc = BlocProvider.of<BusinessBloc>(context, listen: true);
    return Container(
      height: 280,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Expanded(
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 27, 27, 27),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -40),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Routes.profile,
                        arguments: person);
                  },
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 27, 27, 27),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Avatar(
                          name: person.name,
                          urlImage: person.urlImage,
                          size: 80,
                          radius: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  person.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Debet: ${formattedCurrency((person.balance ?? 0).toDouble())}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Button(
                            onPressed: () {
                              businessBloc.add(OnRegisterTransactionEvent(
                                  person: person,
                                  type: TypeTransaction.receive));
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                Routes.registerTransaction,
                              );
                            },
                            label: 'Receive',
                            colorButton: enumColorButton.white,
                            icon: Transform.rotate(
                              angle: 380,
                              child: const Icon(
                                Icons.arrow_outward_rounded,
                                color: AppColors.black800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Button(
                            onPressed: () {
                              businessBloc.add(OnRegisterTransactionEvent(
                                  person: person, type: TypeTransaction.give));
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                Routes.registerTransaction,
                              );
                            },
                            label: 'Give',
                            icon: const Icon(Icons.arrow_outward_rounded),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
