class Genre {
  final int? id;
  final String name;

  Genre({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
