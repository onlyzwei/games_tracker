class Review {
  final int? id;
  final int userId;
  final int gameId;
  final double score;
  final String description;
  final String date;

  Review({this.id, required this.userId, required this.gameId, required this.score, required this.description, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'game_id': gameId,
      'score': score,
      'description': description,
      'date': date,
    };
  }
}
