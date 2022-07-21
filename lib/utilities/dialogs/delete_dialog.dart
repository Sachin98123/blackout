import 'package:blackout/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: 'Delete Note',
      content: 'are you sure you want to delete ?',
      optionBuilder: () => {'cancel': false, 'Log Out': true}).then(
    (value) => value ?? false,
  );
}
