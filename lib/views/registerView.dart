import 'package:blackout/constants/routes.dart';
import 'package:blackout/inputs/showdialog.dart';
import 'package:blackout/services/auth/auth_exception.dart';
import 'package:blackout/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('register')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your Email here'),
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
              //hello
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await Authservice.firebase()
                      .createUser(email: email, password: password);
                  Authservice.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyemail);
                } on WeakPassword {
                  await showErrDialog(
                    context,
                    'Weak Password',
                  );
                } on EmailAlreadyInUse {
                  await showErrDialog(
                    context,
                    'Email already in use ',
                  );
                } on InvalidEmail {
                  await showErrDialog(
                    context,
                    ' Invalid Email',
                  );
                } on GenericAuthException {
                  await showErrDialog(
                    context,
                    'Failed to register ',
                  );
                }
              },
              child: const Text('RegisterB')),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(login, (route) => false);
            },
            child: const Text('already registered? login'),
          ),
        ],
      ),
    );
  }
}
