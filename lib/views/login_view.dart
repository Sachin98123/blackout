import 'package:blackout/constants/routes.dart';
import 'package:blackout/services/auth/auth_exception.dart';
import 'package:blackout/services/auth/auth_service.dart';
import 'package:blackout/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login ')),
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
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  await Authservice.firebase()
                      .logIn(email: email, password: password);
                  final user = Authservice.firebase().currentUser;

                  if (user?.isEmailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyemail,
                      (route) => false,
                    );
                  }
                } on UserNotFound {
                  await showErrorDialog(
                    context,
                    'User not found!',
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Wrong Password Sir!',
                  );
                } on InvalidEmail {
                  await showErrorDialog(
                    context,
                    'Invalid Email ',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'sorry! Authentication Error',
                  );
                }
// these were the Firebase method of handeling the
// exceptions whivh no longer needed
                //  on FirebaseAuthException catch (e) {
                //   devtools.log(e.toString());
                //   devtools.log(e.runtimeType.toString());
                //   devtools.log(e.code);
                //   if (e.code == 'wrong-password') {
                //     await showErrDialog(context, 'Wrong Password Sir!');
                //     devtools.log('wrong password man try again ');
                //   } else if (e.code == 'user-not-found') {
                //     devtools.log('user not found ');
                //     await showErrDialog(context, 'User not found!');
                //   } else if (e.code == 'invalid-email') {
                //     devtools.log('invalid email sir ');
                //     await showErrDialog(context, 'Invalid Email ');
                //   } else {
                //     {
                //       await showErrDialog(context, 'sorry! ${e.code}');
                //     }
                //   }
                // } catch (e) {
                //   await showErrDialog(context, e.toString());
                // }
              },
              child: const Text('Log In')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(register, (route) => false);
              },
              child: const Text('not registered? register'))
        ],
      ),
    );
  }
}
