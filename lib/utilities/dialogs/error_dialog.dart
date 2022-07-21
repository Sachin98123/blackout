import 'package:blackout/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
    context: context,
    title: 'OOPS! An Error Occured ',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
