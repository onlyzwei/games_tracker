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

  static Review fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      gameId: map['game_id'],
      userId: map['user_id'],
      score: map['score'],
      description: map['description'],
      date: map['date'],
    );
  }
}
