/*class Universe {
  final int id;
  final String title;
  final String literaryGenre;
  final String description;

  Universe ({
    required this.id,
    required this.title,
    required this.literaryGenre,
    required this.description,
  });

  factory Universe.fromJson(Map<String, dynamic> json) {
    return Universe(
      id: json['id'] as int,
      title: json['title'] as String,
      literaryGenre: json['literaryGenre'] as String,
      description: json['description'] as String,
    );
  }
}*/

import 'character.dart';

class Universe {
  final int id;
  final String title;
  final String literaryGenre;
  final int numberOfCharacters;
  final List<Character> characters;
  final String description;

  Universe({
    required this.id,
    required this.title,
    required this.literaryGenre,
    required this.numberOfCharacters,
    required this.characters,
    required this.description,
  });

  factory Universe.fromJson(Map<String, dynamic> json) {
    return Universe(
      id: json['id'] as int,
      title: json['title'] as String,
      literaryGenre: json['literaryGenre'] as String,
      numberOfCharacters: json['numberOfCharacters'] as int,
      characters: (json['characters'] as List<dynamic>)
          .map((characterJson) => Character.fromJson(characterJson))
          .toList(),
      description: json['description'] as String,
    );
  }
}