import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/views/bottom_sheet_create_person.dart';
import 'package:molopay/widgets/avatar.dart';

class ListPersons extends StatelessWidget {
  final bool redirect;
  final TypeTransaction type;
  const ListPersons({
    super.key,
    required this.type,
    this.redirect = true,
  });

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
              const _ButtonAdd(),
              ...state.persons.map((e) => GestureDetector(
                    onTap: () {
                      businessBloc.add(
                          OnRegisterTransactionEvent(person: e, type: type));
                      if (redirect) {
                        Navigator.pushNamed(
                            context, Routes.registerTransaction);
                      }
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
                  ))
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
