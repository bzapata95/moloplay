import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart' show AuthenticationOptions;
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/views/list_persons.dart';
import 'package:molopay/widgets/avatar.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';
import 'package:slide_action/slide_action.dart';

import '../app/presentation/global/colors.dart';
import '../routes/routes.dart';

class RegisterTransaction extends StatefulWidget {
  const RegisterTransaction({super.key});

  @override
  State<RegisterTransaction> createState() => _RegisterTransactionState();
}

class _RegisterTransactionState extends State<RegisterTransaction> {
  final FocusNode _focusNode = FocusNode();
  String amount = "";
  String description = "";

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

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

  onProcessRegisterTransaction(BusinessBloc businessBloc) {
    final state = businessBloc.state;
    if (state.personSelected != null &&
        state.typeTransaction != null &&
        amount.isNotEmpty) {
      businessBloc.add(OnCreateTransactionEvent(
        person: state.personSelected!,
        type: state.typeTransaction!,
        amount: double.parse(amount),
        description: description,
      ));
    }

    Navigator.pop(context, Routes.dashboard);
  }

  onHandleRegisterTransaction(BusinessBloc businessBloc) async {
    if (businessBloc.state.isSupportedAuthBiometrics) {
      try {
        final authenticated = await businessBloc.authBiometrics.authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
              // stickyAuth: true,
              // biometricOnly: true,
              ),
        );
        if (authenticated) {
          onProcessRegisterTransaction(businessBloc);
        } else {
          return;
        }
      } catch (e) {
        print(e);
      }
    } else {
      onProcessRegisterTransaction(businessBloc);
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessBloc = BlocProvider.of<BusinessBloc>(context, listen: true);
    final personSelected = businessBloc.state.personSelected;
    final typeTransaction = businessBloc.state.typeTransaction;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            BlocBuilder<BusinessBloc, BusinessState>(builder: (_, state) {
              return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: state.personSelected != null
                          ? const Color(0xff1B1B1B)
                          : Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(25))),
                  child: state.personSelected != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Avatar(
                                  size: 60,
                                  radius: 400,
                                  name: state.personSelected!.name,
                                  urlImage: state.personSelected!.urlImage,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (state.personSelected != null)
                                      Text(state.personSelected!.name,
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 20)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (state.personSelected != null)
                                      Text(
                                        'Debt: S/ ${state.personSelected!.balance != null ? state.personSelected!.balance?.toStringAsFixed(2) : 0}',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Colors.white.withOpacity(0.6)),
                                      )
                                  ],
                                )
                              ],
                            )),
                            IconButton(
                                onPressed: () {
                                  if (state.typeTransaction != null) {
                                    businessBloc.add(OnRegisterTransactionEvent(
                                        type: state.typeTransaction!,
                                        person: null));
                                  }
                                },
                                icon: const Icon(Icons.close))
                          ],
                        )
                      : const ListPersons(
                          hasOpenModal: false,
                        ));
            }),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  BlocBuilder<BusinessBloc, BusinessState>(
                      builder: (_, status) {
                    if (status.typeTransaction != null) {
                      return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color:
                                  status.typeTransaction == TypeTransaction.give
                                      ? Colors.redAccent.shade400
                                      : Colors.greenAccent.shade700,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            status.typeTransaction == TypeTransaction.give
                                ? "Give"
                                : "Receive",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ));
                    }
                    return Container();
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'S/',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: personSelected != null && amount.isNotEmpty
                                  ? double.parse(amount) >
                                              personSelected.balance! &&
                                          typeTransaction ==
                                              TypeTransaction.receive
                                      ? Colors.redAccent.shade400
                                      : Colors.white
                                  : Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          amount.isNotEmpty ? amount : "",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: personSelected != null && amount.isNotEmpty
                                  ? double.parse(amount) >
                                              personSelected.balance! &&
                                          typeTransaction ==
                                              TypeTransaction.receive
                                      ? Colors.redAccent.shade400
                                      : Colors.white
                                  : Colors.white),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    focusNode: _focusNode,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (value) {
                      description = value;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: 'Into a description',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5))),
                  )
                ],
              ),
            ),
            NumericKeyboard(
              onKeyboardTap: (text) {
                handleChangeAmount(text);
              },
              textStyle: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
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
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              leftButtonFn: () {
                handleAddDecimalToAmount();
              },
            ),
            const SizedBox(
              height: 40,
            ),
            SafeArea(
              top: false,
              maintainBottomViewPadding: true,
              child: SlideAction(
                trackHeight: 70,
                trackBuilder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey.withOpacity(0.1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Swipe to register",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  );
                },
                thumbBuilder: (context, state) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.green500,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  );
                },
                action: (amount.isEmpty ||
                        description.isEmpty ||
                        businessBloc.state.personSelected == null ||
                        (personSelected != null &&
                            typeTransaction == TypeTransaction.receive &&
                            double.parse(amount) > personSelected.balance!))
                    ? null
                    : () async {
                        await onHandleRegisterTransaction(businessBloc);
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: AppColors.green500,
                                  content: Text(
                                    'Transaction done!',
                                    style: TextStyle(color: AppColors.white),
                                  )));
                        }
                      },
                disabledColorTint: Colors.grey,
                stretchThumb: true,
                snapAnimationCurve: Curves.bounceInOut,
                actionSnapThreshold: 0.95,
              ),
            )
          ],
        ),
      ),
    );
  }
}
