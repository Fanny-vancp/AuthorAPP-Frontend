import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/character.dart';

// call to api get all characters
Future<List<Character>> fetchCharacters(int idUniverse) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/${idUniverse.toString()}/characters/details"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    List<Character> charactersList = jsonResponse.map((model) => Character.fromJson(model)).toList();
    return charactersList;
  } else {
    throw Exception('Failed to load universe.');
  }
}

// call to api create new character
Future<Character> createCharacter(int idUniverse, String pseudo) async {
  final response = await  http.post(
    Uri.parse("https://localhost:7162/api/universes/${idUniverse.toString()}/characters/details"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, String>{
      'pseudo': pseudo,
    }),
  );

  if (response.statusCode == 201) {
    return Character.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
  else {
    throw Exception('Failed to create character');
  }
}

// call the api get character
Future<Character> fetchCharacter(int characterId) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/1/characters/details/${characterId.toString()}"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    //Iterable jsonResponse = jsonDecode(response.body);
    Character character = Character.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return character;
  } else {
    throw Exception('Failed to load universe.');
  }
}