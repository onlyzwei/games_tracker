import 'package:games_tracker/models/game.dart';
import 'package:games_tracker/controllers/database_controller.dart';

class GameController {
  static const String tableName = "game";

  Future<int> insertGame(Game game) async {
    var db = await DatabaseController().db;
    int id = await db!.insert(tableName, game.toMap());
    return id;
  }

  Future<List<Map<String, dynamic>>> getGames() async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> games = await db!.query(tableName);
    return games;
  }
}
