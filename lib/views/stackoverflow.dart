import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class StackView extends StatefulWidget {
  const StackView({Key? key}) : super(key: key);

  @override
  State<StackView> createState() => _StackViewState();
}

class _StackViewState extends State<StackView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Enter your Email here'),
        ),
        TextField(
          controller: _password,
          enableSuggestions: false,
          autocorrect: false,
          obscureText: true,
          decoration:
              const InputDecoration(hintText: 'Enter your Password here'),
        ),
        TextButton(
             onPressed: () async {
                    print('attempting to send verification email');
                    try {
                      await user.sendEmailVerification();
                      print("sent");
                      CustomAlertDialog.messageAlertDialog(
                        context,
                        'Verification email sent',
                        '',
                        "Continue",
                      );
                    } catch (error) {
                      print("error sending verification error: $error");
                      CustomAlertDialog.messageAlertDialog(
                        context,
                        'Verification email failed',
                        error,
                        "Continue",
                      );
                    }
                  }
            child: const Text('RegisterB'))
      ],
    );
  }
}