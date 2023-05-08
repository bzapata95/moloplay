import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/authentication/authentication_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/views/list_persons.dart';
import 'package:molopay/widgets/button.dart';
import 'package:molopay/widgets/card_transaction.dart';
import 'package:molopay/widgets/header.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final businessBloc = BlocProvider.of<BusinessBloc>(context, listen: true);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          businessBloc.add(
              const OnRegisterTransactionEvent(type: TypeTransaction.receive));
          Navigator.pushNamed(context, Routes.registerTransaction);
        },
        child: const Icon(
          Icons.move_to_inbox_rounded,
          size: 28,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeaderDashboard(businessBloc: businessBloc),
            Column(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20)
                        .copyWith(top: 40, bottom: 10),
                    child: const Header(
                      title: 'Recent',
                      titleButton: 'view all',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ListPersons()
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20)
                      .copyWith(bottom: 10),
                  child: BlocBuilder<BusinessBloc, BusinessState>(
                      builder: (_, state) {
                    return Column(
                      children: [
                        Header(
                          title: 'History',
                          titleButton: 'view all',
                          onRedirect: () {
                            Navigator.pushNamed(context, Routes.allTransaction);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ...state.transactions.map(
                          (e) => GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.detailsTransaction,
                                  arguments: e);
                            },
                            child: Column(
                              children: [
                                CardTransaction(
                                  transaction: e,
                                ),
                                const SizedBox(
                                  height: 12,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class _HeaderDashboard extends StatelessWidget {
  final BusinessBloc businessBloc;
  const _HeaderDashboard({
    super.key,
    required this.businessBloc,
  });

  calculateSayHello() {
    final nowHour = DateTime.now().hour;
    if (nowHour > 0 && nowHour < 12) {
      return 'Good morning';
    }
    if (nowHour >= 12 && nowHour < 18) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    const double heightHeader = 360;
    const borderRadiusContainerHeader = Radius.circular(40);
    return Stack(
      children: [
        Container(
          height: heightHeader,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff338075), Color(0xff1A5450)]),
              borderRadius: BorderRadius.only(
                  bottomLeft: borderRadiusContainerHeader,
                  bottomRight: borderRadiusContainerHeader)),
        ),
        SizedBox(
          height: heightHeader,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.menu),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(calculateSayHello(),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white.withOpacity(0.6))),
                              const SizedBox(
                                height: 2,
                              ),
                              BlocBuilder<AuthenticationBloc,
                                  AuthenticationState>(builder: (_, state) {
                                if (state.username.isNotEmpty) {
                                  return Text(
                                    state.username,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat'),
                                  );
                                }
                                return Text("");
                              })
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.notifications),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your total balance',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8)),
                          ),
                          BlocBuilder<BusinessBloc, BusinessState>(
                              builder: (_, state) {
                            return IconButton(
                                onPressed: () {
                                  businessBloc.add(
                                      OnToggleVisibilityTotalBalanceEvent());
                                },
                                icon: Icon(
                                  state.isVisibilityTotalBalance
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility,
                                  color: Colors.white.withOpacity(0.8),
                                ));
                          })
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      BlocBuilder<BusinessBloc, BusinessState>(
                          builder: (_, state) {
                        return Text(
                            state.isVisibilityTotalBalance
                                ? state.totalBalance
                                : '*********',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 40,
                                fontWeight: FontWeight.bold));
                      }),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Button(
                                onPressed: () {
                                  businessBloc.add(
                                      const OnRegisterTransactionEvent(
                                          person: null,
                                          type: TypeTransaction.receive));
                                  Navigator.pushNamed(
                                      context, Routes.registerTransaction);
                                },
                                label: 'Receive',
                                colorButton: enumColorButton.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Button(
                                  onPressed: () {
                                    businessBloc.add(
                                        const OnRegisterTransactionEvent(
                                            person: null,
                                            type: TypeTransaction.give));
                                    Navigator.pushNamed(
                                        context, Routes.registerTransaction);
                                  },
                                  label: 'Give'),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
