class Game {
  final int? id;
  final int userId;
  final String name;
  final String description;
  final String releaseDate;

  Game({this.id, required this.userId, required this.name, required this.description, required this.releaseDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'release_date': releaseDate,
    };
  }
}
