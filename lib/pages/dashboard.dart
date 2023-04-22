import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/authentication/authentication_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/views/bottom_sheet_create_person.dart';
import 'package:molopay/widgets/avatar.dart';
import 'package:molopay/widgets/button.dart';
import 'package:molopay/widgets/card_transaction.dart';
import 'package:molopay/widgets/header.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final businessBloc = BlocProvider.of<BusinessBloc>(context, listen: true);
    return Scaffold(
      body: Column(
        children: [
          const _HeaderDashboard(),
          Column(children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20)
                      .copyWith(top: 40, bottom: 10),
                  child: const Header(
                    title: 'quick give',
                    titleButton: 'view all',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 115,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20),
                    children: [
                      const _ButtonAdd(),
                      ...businessBloc.state.persons.map((e) => GestureDetector(
                            onTap: () {
                              businessBloc.add(
                                  OnSelectedPersonForRegisterTransactionEvent(
                                      person: e, type: TypeTransaction.give));
                              Navigator.pushNamed(
                                  context, Routes.registerTransaction);
                            },
                            child: Container(
                              width: 90,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Avatar(
                                    size: 90,
                                    radius: 30,
                                    name: e.name,
                                  ),
                                  Text(
                                    e.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(bottom: 10),
              child: Column(
                children: const [
                  Header(
                    title: 'history',
                    titleButton: 'view all',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CardTransaction()
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }
}

class _ButtonAdd extends StatelessWidget {
  const _ButtonAdd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return const BottomSheetCreatePerson();
            });
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 58, 58, 58).withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: const Center(
            child: Text(
              "+",
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderDashboard extends StatelessWidget {
  const _HeaderDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadiusContainerHeader = Radius.circular(40);
    return Stack(
      children: [
        Container(
          height: 400,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff338075), Color(0xff1A5450)]),
              borderRadius: BorderRadius.only(
                  bottomLeft: borderRadiusContainerHeader,
                  bottomRight: borderRadiusContainerHeader)),
        ),
        Container(
          height: 400,
          child: SafeArea(
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
                              Text("good morning",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6))),
                              const SizedBox(
                                height: 2,
                              ),
                              BlocBuilder<AuthenticationBloc,
                                  AuthenticationState>(builder: (_, state) {
                                if (state.username.isNotEmpty) {
                                  return Text(state.username);
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
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                          Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.white.withOpacity(0.8),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text('S/ 12,739.85',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Button(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, Routes.registerTransaction);
                            },
                            label: 'Receive',
                            colorButton: enumColorButton.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Button(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.registerTransaction);
                              },
                              label: 'Give'),
                        ],
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
