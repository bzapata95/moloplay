import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/blocs/business/business_bloc.dart';
import 'package:molopay/widgets/button.dart';

class BottomSheetCreatePerson extends StatelessWidget {
  const BottomSheetCreatePerson({super.key});

  handleSendPerson(BuildContext context, name) {
    final blocBusiness = BlocProvider.of<BusinessBloc>(context);
    blocBusiness.add(OnAddPersonEvent(name));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final namePersonController = TextEditingController();
    return Container(
      height: 300,
      decoration: const BoxDecoration(
          color: Color(0xff0F0F0F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(children: [
          TextField(
            controller: namePersonController,
            textCapitalization: TextCapitalization.words,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
                hintText: 'Enter person name',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3))),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Button(
              onPressed: () {
                handleSendPerson(context, namePersonController.text);
                namePersonController.text = "";
              },
              label: "Register",
              colorButton: enumColorButton.white,
            ),
          )
        ]),
      ),
    );
  }
}
