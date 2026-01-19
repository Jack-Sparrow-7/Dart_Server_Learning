class Post {
  final String name;
  final String description;
  final int age;

  Post({required this.name, required this.description, required this.age});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    name: json['name'],
    description: json['description'],
    age: json['age'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'age': age,
  };
}
