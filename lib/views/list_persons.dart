import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/views/bottom_sheet_create_person.dart';
import 'package:molopay/widgets/avatar.dart';

class ListPersons extends StatelessWidget {
  final bool hasOpenModal;
  // final TypeTransaction type;
  const ListPersons({
    super.key,
    this.hasOpenModal = true,
    // this.redirect = true,
  });

  onHandleRegisterTransaction({
    required BusinessBloc businessBloc,
    required BuildContext context,
    required Person person,
    required TypeTransaction type,
  }) {
    businessBloc.add(OnRegisterTransactionEvent(person: person, type: type));
    Navigator.pop(context);
    Navigator.pushNamed(context, Routes.registerTransaction);
  }

  @override
  Widget build(BuildContext context) {
    final businessBloc = BlocProvider.of<BusinessBloc>(context, listen: true);
    return SizedBox(
      height: 115,
      child: BlocBuilder<BusinessBloc, BusinessState>(
        builder: (context, state) {
          return ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20),
            children: [
              ...state.persons.map((e) => GestureDetector(
                    onTap: () {
                      if (hasOpenModal == false &&
                          businessBloc.state.typeTransaction != null) {
                        businessBloc.add(OnRegisterTransactionEvent(
                            person: e,
                            type: businessBloc.state.typeTransaction!));
                        return;
                      }
                      // // if (redirect) {
                      // Navigator.pushNamed(context, Routes.registerTransaction);
                      // // }
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => CupertinoActionSheet(
                          title: Text('Operation'),
                          actions: <Widget>[
                            // CupertinoActionSheetAction(
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: const [
                            //       Text('Profile'),
                            //       SizedBox(
                            //         width: 5,
                            //       ),
                            //       Icon(
                            //         Icons.person,
                            //         color: Colors.blueAccent,
                            //       )
                            //     ],
                            //   ),
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //     // Acción a realizar al seleccionar la opción 2
                            //   },
                            // ),
                            CupertinoActionSheetAction(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Give',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_upward_outlined,
                                    color: Colors.redAccent,
                                  )
                                ],
                              ),
                              onPressed: () {
                                onHandleRegisterTransaction(
                                  businessBloc: businessBloc,
                                  context: context,
                                  person: e,
                                  type: TypeTransaction.give,
                                );
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Receive',
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_downward_outlined,
                                    color: Colors.greenAccent,
                                  )
                                ],
                              ),
                              onPressed: () {
                                onHandleRegisterTransaction(
                                  businessBloc: businessBloc,
                                  context: context,
                                  person: e,
                                  type: TypeTransaction.receive,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              fontFamily: 'Montserrat',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              const _ButtonAdd(),
            ],
          );
        },
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
