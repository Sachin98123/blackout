import 'package:blackout/firebase_options.dart';
import 'package:blackout/views/login_view.dart';
import 'package:blackout/views/registerView.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final User = FirebaseAuth.instance.currentUser;
              if (User?.emailVerified ?? false) {
                print('you are a verified user ');
              } else {
                print('you need to verify your email first !');
              }
              return const Text('done');
            default:
              return const Text('loading...');
          }
        },
      ),
    );
  }
}
