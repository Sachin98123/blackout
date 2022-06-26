import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Enter your Email here'),
                  ),
                  TextField(
                    controller: _password,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: 'Enter your Password here'),
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        try {
                          final UserCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(UserCredential);
                        } on FirebaseAuthException catch (e) {
                          print(e);
                          print(e.runtimeType);
                          print(e.code);
                          if (e.code == 'wrong-password') {
                            print('wrong password man try again ');
                          } else if (e.code == 'user-not-found') {
                            print('user not found ');
                          } else if (e.code == 'weak-password') {
                            print('weak Password sir!');
                          } else if (e.code == 'email-already-in-use') {
                            print(
                                'Enter another email cz this one is already in use ');
                          } else if (e.code == 'invalid-email') {
                            print('invalid email sir ');
                          }
                        }
                      },
                      child: const Text('Log In'))
                ],
              );
            default:
              return const Text('loading...');
          }
        },
      ),
    );
  }
}