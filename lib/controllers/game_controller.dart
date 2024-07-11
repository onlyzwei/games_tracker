import 'package:games_tracker/models/game.dart';
import 'package:games_tracker/controllers/database_controller.dart';

class GameController {
  static const String tableName = "game";
  static final GameController _gameController = GameController._internal();

  factory GameController() {
    return _gameController;
  }

  GameController._internal();

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

  Future<void> deleteGame(int? gameId) async {
    if (gameId == null) {
      throw ArgumentError('gameId must not be null'); // Lança uma exceção se gameId for null
    }

    var db = await DatabaseController().db;
    await db!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [gameId],
    );
  }

  Future<double?> getAverageScore(int gameId) async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> result = await db!.rawQuery(
        'SELECT AVG(score) as avg_score FROM review WHERE game_id = ?',
        [gameId]);

    if (result.isNotEmpty && result.first['avg_score'] != null) {
      return result.first['avg_score'];
    } else {
      return null;
    }
  }

  Future<Game> getGameById(int gameId) async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> games = await db!.query(
      tableName,
      where: "id = ?",
      whereArgs: [gameId],
    );

    if (games.isNotEmpty) {
      return Game.fromMap(games.first);
    } else {
      throw Exception('Game with id $gameId not found');
    }
  }

  Future<int> updateGame(Game game) async {
    var db = await DatabaseController().db;
    int result = await db!.update(
      tableName,
      game.toMap(),
      where: "id = ?",
      whereArgs: [game.id],
    );
    return result;
  }
}
