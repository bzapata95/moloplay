import 'package:flutter/material.dart'
    show BuildContext, Colors, showModalBottomSheet;

import '../../../views/bottom_sheet_create_person.dart';

void openModalAddPerson(
  BuildContext context, {
  Function? onRegister,
}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BottomSheetCreatePerson(
          onRegister: onRegister,
        );
      });
}
