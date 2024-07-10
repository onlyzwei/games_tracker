import 'package:games_tracker/models/genre.dart';
import 'package:games_tracker/controllers/database_controller.dart';

class GenreController {
  static const String tableName = "genre";

  Future<int> insertGenre(Genre genre) async {
    var db = await DatabaseController().db;
    int id = await db!.insert(tableName, genre.toMap());
    return id;
  }

  Future<List<Map<String, dynamic>>> getGenres() async {
    var db = await DatabaseController().db;
    List<Map<String, dynamic>> genres = await db!.query(tableName);
    return genres;
  }
}
