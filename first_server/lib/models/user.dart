class User {
  final Object? id;
  final String username;
  final String password;
  final String email;
  final DateTime createdAt;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.createdAt,
    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'password': password,
      'email': email,
      'createdAt': createdAt,
    };
  }
}
