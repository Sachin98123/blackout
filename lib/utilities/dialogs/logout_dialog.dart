import 'package:blackout/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Log Out',
      content: 'Are you Sure You Want To Log Out?',
      optionBuilder: () => {
            'cancel': false,
            'Log Out': true,
          }).then(
    (value) => value ?? false,
  );
}
