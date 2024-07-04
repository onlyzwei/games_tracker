import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'games_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR NOT NULL,
        email VARCHAR NOT NULL,
        password VARCHAR NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE genre(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE game(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name VARCHAR NOT NULL UNIQUE,
        description TEXT NOT NULL,
        release_date VARCHAR NOT NULL,
        FOREIGN KEY(user_id) REFERENCES user(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE game_genre(
        game_id INTEGER NOT NULL,
        genre_id INTEGER NOT NULL,
        FOREIGN KEY(game_id) REFERENCES game(id),
        FOREIGN KEY(genre_id) REFERENCES genre(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE review(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        game_id INTEGER NOT NULL,
        score REAL NOT NULL,
        description TEXT NOT NULL,
        date VARCHAR NOT NULL,
        FOREIGN KEY(user_id) REFERENCES user(id),
        FOREIGN KEY(game_id) REFERENCES game(id)
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
