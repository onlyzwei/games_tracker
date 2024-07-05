import 'package:games_tracker/models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io' as io;

class UserController {
  static const String tableName = "user";
  static final UserController _userController = UserController._internal();
  static Database? _db;

  factory UserController() {
    return _userController;
  }

  UserController._internal();

  Future<Database?> get db async {
    /*if (_db == null) {
      _db = initDb();
    }
    If é substituído pelo comando "??="
    */

    _db ??= await _initDb();

    return _db;
  }

  Future<Database?> _initDb() async {
    sqfliteFfiInit();

    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = p.join(appDocumentsDir.path, "databases", "user.db");

    Database? db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          String sql = """
          CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL,
            email VARCHAR NOT NULL,
            password VARCHAR NOT NULL
          );
          """;
          await db.execute(sql);
        }
      )
    );
    return db;  
  }

  Future<int> insertUser(User user) async {
    var database = await db;

    int id = await database!.insert(tableName, user.toMap());

    return id;
  }

  getUsers() async {
    var database = await db;
    String sql = "SELECT * FROM $tableName";

    List users = await database!.rawQuery(sql);

    return users;
  }

  Future<int> updateUser(User user) async {
    var database = await db;

    int result = await database!.update(
      tableName,
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id!]
    );
    return result;
  }

  Future<int> deleteUser(int id) async {
    var database = await db;

    int result = await database!.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id]
    );
    return result;
  }
}