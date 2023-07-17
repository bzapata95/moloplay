import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/app/presentation/global/colors.dart';
import 'package:molopay/blocs/authentication/authentication_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/views/list_persons.dart';
import 'package:molopay/widgets/button.dart';
import 'package:molopay/widgets/card_transaction.dart';
import 'package:molopay/widgets/header.dart';
import 'package:local_auth/local_auth.dart';

import '../views/drawer_content.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final keyScaffold = GlobalKey<ScaffoldState>();
    final businessBloc = BlocProvider.of<BusinessBloc>(context, listen: true);

    return Scaffold(
      key: keyScaffold,
      drawer: Drawer(
        child: DrawerContentView(keyScaffold: keyScaffold),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeaderDashboard(
                businessBloc: businessBloc, keyScaffold: keyScaffold),
            Column(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20)
                        .copyWith(top: 40, bottom: 10),
                    child: const Header(
                      title: 'Recent',
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
                          (e) {
                            return GestureDetector(
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
                                  const Divider(
                                    height: 12,
                                  )
                                ],
                              ),
                            );
                          },
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
  final GlobalKey<ScaffoldState> keyScaffold;

  const _HeaderDashboard({
    super.key,
    required this.businessBloc,
    required this.keyScaffold,
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

  onHandleShowTotalBalance() async {
    final canCheckBiometrics =
        await businessBloc.authBiometrics.canCheckBiometrics;
    if (businessBloc.state.isVisibilityTotalBalance) {
      businessBloc.add(OnToggleVisibilityTotalBalanceEvent());

      return;
    }

    if (businessBloc.state.isSupportedAuthBiometrics && canCheckBiometrics) {
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
          businessBloc.add(OnToggleVisibilityTotalBalanceEvent());
        }
      } catch (e) {
        // canCheckBiometrics = false;
        print(e);
      }
    } else {
      businessBloc.add(OnToggleVisibilityTotalBalanceEvent());
    }
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
                          IconButton(
                              onPressed: () {
                                keyScaffold.currentState!.openDrawer();
                              },
                              icon: const Icon(Icons.menu)),
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
                            'Balance',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8)),
                          ),
                          BlocBuilder<BusinessBloc, BusinessState>(
                              builder: (_, state) {
                            return IconButton(
                                onPressed: () {
                                  // Validate Biometric authentication
                                  onHandleShowTotalBalance();
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
                                    context,
                                    Routes.allPersons,
                                    arguments: {'onlySelect': true},
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
                                  businessBloc.add(
                                      const OnRegisterTransactionEvent(
                                          person: null,
                                          type: TypeTransaction.give));
                                  Navigator.pushNamed(
                                    context,
                                    Routes.allPersons,
                                    arguments: {'onlySelect': true},
                                  );
                                },
                                label: 'Give',
                                icon: const Icon(Icons.arrow_outward_rounded),
                              ),
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
