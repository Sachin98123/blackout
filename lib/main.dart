import 'package:blackout/constants/routes.dart';
import 'package:blackout/services/auth/auth_service.dart';
import 'package:blackout/verifyemailview.dart';
import 'package:blackout/views/login_view.dart';
import 'package:blackout/views/notes/new_note_view.dart';
import 'package:blackout/views/notes/notes_view.dart';
import 'package:blackout/views/register_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
    routes: {
      login: (context) => const LoginView(),
      register: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyemail: (context) => const VerifyEmailView(),
      newNoteRaute: (context) => const NewNotesView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Authservice.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = Authservice.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
