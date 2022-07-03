import 'package:blackout/constants/routes.dart';
import 'package:blackout/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main UI'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logOut:
                    final shouldLogOut = await showLogOutDialog(context);
                    if (shouldLogOut) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(login, (_) => false);
                    }
                }
                devtool.log(value.toString());
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logOut, child: Text('logOut'))
                ];
              },
            )
          ],
        ),
        body: Column(
          children: const [
            Text('welcome to the demo application '),
            SizedBox(
              height: 20,
              width: 20,
            ),
            Text(
              'Nothing but Just a try ',
              style: TextStyle(color: Colors.deepOrangeAccent),
            ),
          ],
        ));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('sign out '),
          content: const Text('Are you sure ?'),
          backgroundColor: const Color.fromARGB(255, 52, 126, 124),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Log Out',
                style: TextStyle(
                  backgroundColor: Colors.cyanAccent,
                ),
              ),
            )
          ],
        );
      }).then((value) => value ?? false);
}