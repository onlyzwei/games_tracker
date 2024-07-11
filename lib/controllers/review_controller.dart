import 'package:games_tracker/controllers/database_controller.dart';
import 'package:games_tracker/models/review.dart';

class ReviewController {
  static const String tableName = "review";
  static final ReviewController _reviewController = ReviewController._internal();

  factory ReviewController() {
    return _reviewController;
  }

  ReviewController._internal();

  Future<List<Review>> getReviewsByGameId(int gameId) async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> maps = await db!.query(tableName, where: 'game_id = ?', whereArgs: [gameId]);

    if (maps.isNotEmpty) {
      return maps.map((map) => Review.fromMap(map)).toList();
    } else {
      return [];
    }
  }

  Future<int> addReview(int gameId, int userId, double score, String description, String date) async {
    var db = await DatabaseController().db;
    return await db!.insert(tableName, {
      'game_id': gameId,
      'user_id': userId,
      'score': score,
      'description': description,
      'date': date,
    });
  }

  Future<int> updateReview(int id, double score, String description) async {
    var db = await DatabaseController().db;
    return await db!.update(
      tableName,
      {
        'score': score,
        'description': description,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReview(int id) async {
    var db = await DatabaseController().db;
    return await db!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  
}
