// ignore_for_file: avoid_print

class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  User({this.id, required this.name, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  static Future<User?> fromMap(Map<String, dynamic> map) async {
    try {
      int id = map['id'];
      String name = map['name'];
      String email = map['email'];
      String password = map['password'];
      User user = User(
        id: id,
        name: name,
        email: email,
        password: password,
      );
      return user;
    } catch (e) {
      print('Error parsing user from map: $e');
      return null;
    }
  }
}
