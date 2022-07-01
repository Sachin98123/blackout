import 'package:blackout/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as devtools show log;

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
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  devtools.log(userCredential.toString());
                } on FirebaseAuthException catch (e) {
                  devtools.log(e.toString());
                  devtools.log(e.runtimeType.toString());
                  devtools.log(e.code);
                  if (e.code == 'wrong-password') {
                    devtools.log('wrong password man try again ');
                  } else if (e.code == 'user-not-found') {
                    devtools.log('user not found ');
                  } else if (e.code == 'weak-password') {
                    devtools.log('weak Password sir!');
                  } else if (e.code == 'email-already-in-use') {
                    devtools.log(
                        'Enter another email cz this one is already in use');
                  } else if (e.code == 'invalid-email') {
                    devtools.log('invalid email sir ');
                  }
                }
              },
              child: const Text('RegisterB')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(login, (route) => false);
              },
              child: const Text('already registered? login'))
        ],
      ),
    );
  }
}
