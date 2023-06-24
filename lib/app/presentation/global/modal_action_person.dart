import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/models/person.dart';

import '../../../blocs/business/business_bloc.dart';
import '../../../models/transaction.dart';
import '../../../routes/routes.dart';

_onHandleRegisterTransaction({
  required BusinessBloc businessBloc,
  required BuildContext context,
  required Person person,
  required TypeTransaction type,
}) {
  businessBloc.add(OnRegisterTransactionEvent(person: person, type: type));
  Navigator.pop(context);
  Navigator.pushNamed(context, Routes.registerTransaction);
}

openModalActionPerson(
  BuildContext context,
  Person e,
) {
  final businessBloc = BlocProvider.of<BusinessBloc>(context, listen: false);
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      title: Text('Operation'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Profile'),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.person,
                color: Colors.blueAccent,
              )
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.profile, arguments: e);
            // Acción a realizar al seleccionar la opción 2
          },
        ),
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
            _onHandleRegisterTransaction(
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
            _onHandleRegisterTransaction(
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
}
