class Character {
  final int id;
  final String name;
  final String description;

  Character({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}