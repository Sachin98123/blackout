import 'package:blackout/constants/routes.dart';
import 'package:blackout/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('verify Email view'),
      ),
      body: Column(
        children: [
          const Text(
            'We\'ve send you the verifiacation mail in your gmail PLease verify',
          ),
          const Divider(
            height: 20,
          ),
          const Text(
            'didn\'t reccieved an email ? Click on verify email below😸 ',
          ),
          TextButton(
              onPressed: () async {
                Authservice.firebase().sendEmailVerification();
              },
              child: const Text('verify email')),
          const SizedBox(
            width: 20,
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              await Authservice.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                register,
                (route) => false,
              );
            },
            child: const Text('return'),
          ),
        ],
      ),
    );
  }
}
