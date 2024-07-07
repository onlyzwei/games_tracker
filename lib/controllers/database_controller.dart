import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;

class DatabaseController {
  static final DatabaseController _instance = DatabaseController._internal();
  static Database? _db;

  factory DatabaseController() {
    return _instance;
  }

  DatabaseController._internal();

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<Database?> _initDb() async {
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = p.join(appDocumentsDir.path, "games_tracker.db");

    Database? db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute("""
            CREATE TABLE user(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL,
              email VARCHAR NOT NULL,
              password VARCHAR NOT NULL
            );
          """);
          await db.execute("""
            CREATE TABLE genre(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name VARCHAR NOT NULL
            );
          """);
          await db.execute("""
            CREATE TABLE game(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              name VARCHAR NOT NULL UNIQUE,
              description TEXT NOT NULL,
              release_date VARCHAR NOT NULL,
              FOREIGN KEY(user_id) REFERENCES user(id)
            );
          """);
          await db.execute("""
            CREATE TABLE game_genre(
              game_id INTEGER NOT NULL,
              genre_id INTEGER NOT NULL,
              FOREIGN KEY(game_id) REFERENCES game(id),
              FOREIGN KEY(genre_id) REFERENCES genre(id)
            );
          """);
          await db.execute("""
            CREATE TABLE review(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL,
              game_id INTEGER NOT NULL,
              score REAL NOT NULL,
              description TEXT NOT NULL,
              date VARCHAR NOT NULL,
              FOREIGN KEY(user_id) REFERENCES user(id),
              FOREIGN KEY(game_id) REFERENCES game(id)
            );
          """);
        }
      )
    );
    return db;
  }

}
