import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/widgets/avatar.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:slide_to_act/slide_to_act.dart';

class RegisterTransaction extends StatefulWidget {
  const RegisterTransaction({super.key});

  @override
  State<RegisterTransaction> createState() => _RegisterTransactionState();
}

class _RegisterTransactionState extends State<RegisterTransaction> {
  String amount = "";

  handleChangeAmount(String text) {
    amount = amount + text;
    setState(() {});
  }

  handleDeleteOneDigit() {
    if (amount.isNotEmpty) {
      amount = amount.replaceRange(amount.length - 1, null, "");
      setState(() {});
    }
  }

  handleAddDecimalToAmount() {
    if (amount.isNotEmpty && amount.contains(".") == false) {
      amount = "$amount.";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessBloc = BlocProvider.of<BusinessBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Color(0xff1B1B1B),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Avatar(
                        size: 60,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      BlocBuilder<BusinessBloc, BusinessState>(
                          builder: (_, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.personSelected != null)
                              Text(state.personSelected!.name,
                                  style: TextStyle(fontSize: 20)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Debe: S/ 302.2',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6)),
                            ),
                          ],
                        );
                      })
                    ],
                  )),
                  // Icon(Icons.close)
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: const BoxDecoration(
                          color: Color(0XFFE45735),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: BlocBuilder<BusinessBloc, BusinessState>(
                        builder: (_, status) {
                          if (status.typeTransaction != null) {
                            print(status.typeTransaction);
                            return Text(
                              status.typeTransaction == TypeTransaction.give
                                  ? "Give"
                                  : "Receive",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            );
                          }
                          return Container();
                        },
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'S/',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          amount.isNotEmpty ? amount : "",
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            NumericKeyboard(
              onKeyboardTap: (text) {
                handleChangeAmount(text);
              },
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              rightButtonFn: () {
                handleDeleteOneDigit();
              },
              rightButtonLongPressFn: () {
                amount = "";
                setState(() {});
              },
              rightIcon: const Icon(
                Icons.backspace,
                color: Colors.white,
              ),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              leftIcon: Container(
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              leftButtonFn: () {
                handleAddDecimalToAmount();
              },
            ),
            const SizedBox(
              height: 40,
            ),
            SafeArea(
                child: SlideAction(
              innerColor: Color(0xff348276),
              outerColor: Color(0xff1b1b1b),
              borderRadius: 20,
              height: 80,
              text: 'swipe to register',
              textStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              elevation: 0,
              sliderButtonIcon: const Icon(
                Icons.keyboard_arrow_right_sharp,
                color: Colors.white,
                size: 32,
              ),
              sliderRotate: false,
              onSubmit: () {
                final state = businessBloc.state;
                if (state.personSelected != null &&
                    state.typeTransaction != null &&
                    amount.isNotEmpty) {
                  businessBloc.add(OnCreateTransactionEvent(
                    person: state.personSelected!,
                    type: state.typeTransaction!,
                    amount: double.parse(amount),
                  ));
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
