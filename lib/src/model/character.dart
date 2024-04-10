class Character {
  final int id;
  final String name;
  final String description;
  final String gender;
  final String eyeColor;
  final String hairColor;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.gender,
    required this.eyeColor,
    required this.hairColor,
  }); 

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      gender: json['gender'] as String,
      eyeColor: json['eyeColor'] as String,
      hairColor: json['hairColor'] as String,
    );
  }
}