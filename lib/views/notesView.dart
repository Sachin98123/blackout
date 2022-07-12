import 'package:blackout/constants/routes.dart';
import 'package:blackout/services/auth/auth_service.dart';
import 'package:blackout/services/crud/note_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  late final NotesService _notesService;
  String get userEmail => Authservice.firebase().currentUser!.email!;
 
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
                      await Authservice.firebase().logOut();
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
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('waiting for the notes');
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
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
