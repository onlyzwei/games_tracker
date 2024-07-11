import 'package:games_tracker/models/review.dart';
import 'package:games_tracker/controllers/database_controller.dart';

class ReviewController {
  static const String tableName = "review";

  Future<int> insertReview(Review review) async {
    var db = await DatabaseController().db;
    int id = await db!.insert(tableName, review.toMap());
    return id;
  }

  Future<List<Map<String, dynamic>>> getReviews() async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> reviews = await db!.query(tableName);
    return reviews;
  }
}
