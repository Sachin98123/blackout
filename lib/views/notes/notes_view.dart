import 'package:blackout/constants/routes.dart';
import 'package:blackout/services/auth/auth_service.dart';
import 'package:blackout/services/crud/note_service.dart';
import 'package:blackout/utilities/dialogs/logout_dialog.dart';
import 'package:blackout/views/notes/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

import '../../enums/menu_action.dart';

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

  late final NotesService _notesService;
  String get userEmail => Authservice.firebase().currentUser!.email!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main UI'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(newNoteRaute);
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logOut:
                    final shouldLogOut = await showLogoutDialog(context);
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
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allNotes = snapshot.data as List<DataNotes>;
                          return NotesListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _notesService.deleteNotes(id: note.id);
                              });
                        } else {
                          return const Text('waiting for the data');
                        }
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
