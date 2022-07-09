import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const isSyncedWithCloudColumn = 'sync_cloud';
const textColumn = 'text';
const dbName = 'notes.db';
const noteTable = 'table';
const userTable = 'user';

class DataBaseAlreadyOpenException {}

class DataBaseIsNotOpenException {}

class UnableToGetDocumentDirectory {}

class NotesService {
  Database? _db;
  Future<void> open() async {
    if (_db != null) {
      throw DataBaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;
  @override
  String toString() => 'person, id=$id,email=$email';
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  const DataNotes(
      {required this.id,
      required this.userId,
      required this.isSyncedWithCloud,
      required this.text});

  DataNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false,
        text = map[textColumn] as String;
  @override
  String toString() =>
      'notes,id=$id,userId=$userId,isSyncedWithCloud=$isSyncedWithCloud,text=$text';
  @override
  bool operator ==(covariant DataNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const createUserTable =
    '''CREATE TABLE IF NOT EXISTS "user"("id" INTEGER NOT NULL ,
     "email" TEXT NOT NULL UNIQUE, PRIMARY KEY("id" AUTOINCREMENT));''';

const createNoteTable = '''   
      CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"sync_cloud"	INTEGER DEFAULT 0,
	FOREIGN KEY("user_id") REFERENCES "user"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);''';
