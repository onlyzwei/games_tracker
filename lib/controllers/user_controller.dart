import 'package:games_tracker/models/user.dart';
import 'package:games_tracker/controllers/database_controller.dart';

class UserController {
  static const String tableName = "user";
  static final UserController _userController = UserController._internal();

  factory UserController() {
    return _userController;
  }

  UserController._internal();

  Future<int> insertUser(User user) async {
    var db = await DatabaseController().db;
    int id = await db!.insert(tableName, user.toMap());
    return id;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> users =
        await db!.rawQuery('SELECT * FROM $tableName');
    return users;
  }

  Future<int> updateUser(User user) async {
    var db = await DatabaseController().db;
    int result = await db!.update(
      tableName,
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
    return result;
  }

  Future<int> deleteUser(int id) async {
    var db = await DatabaseController().db;
    int result = await db!.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  Future<User?> getUser(String email, String password) async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> users = await db!.query(
      tableName,
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );

    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    } else {
      return null;
    }
  }

  Future<bool> checkEmailExists(String email) async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> users = await db!.query(
      tableName,
      where: "email = ?",
      whereArgs: [email],
    );

    return users.isNotEmpty;
  }
}
