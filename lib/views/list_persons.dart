import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/utils/responsive.dart';
import 'package:molopay/views/bottom_sheet_create_person.dart';
import 'package:molopay/widgets/avatar.dart';

import '../app/presentation/global/modal_action_person.dart';

class ListPersons extends StatelessWidget {
  final bool hasOpenModal;
  // final TypeTransaction type;
  const ListPersons({
    super.key,
    this.hasOpenModal = true,
    // this.redirect = true,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
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

                      openModalActionPerson(context, e);
                    },
                    child: Container(
                      width: responsive.dp(9.5),
                      margin: EdgeInsets.only(right: responsive.wp(2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Avatar(
                            size: 90,
                            radius: responsive.dp(50),
                            name: e.name,
                            urlImage: e.urlImage,
                          ),
                          Text(
                            e.name.split(" ")[0],
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
    final responsive = Responsive.of(context);
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
        width: responsive.dp(10),
        margin: const EdgeInsets.only(right: 12),
        child: Container(
          height: responsive.dp(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 58, 58, 58).withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(responsive.dp(50))),
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
