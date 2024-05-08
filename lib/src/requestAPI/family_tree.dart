import 'dart:convert';

import 'package:http/http.dart' as http;

import '../requestAPI/universe.dart';
import '../model/character_node.dart';

// call the api to add a character in the family tree
Future<void> addCharacterTree(String characterName, String familyTreeName) async {
  final response = await  http.post(
    Uri.parse("https://localhost:7162/api/families_trees/$familyTreeName/characters"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, String>{
      'stratPoint': characterName,
      'endPoint': familyTreeName,
      'descriptionRelation' : '',
    }),
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to add a character');
  }
}

// call the api to create a relation between two characters
Future<void> createRelation(String characterName1, String characterName2, String descriptionRelation, String familyTreeName) async {
  final response = await  http.post(
    Uri.parse("https://localhost:7162/api/families_trees/$familyTreeName/characters/relation"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, String>{
      'stratPoint': characterName1,
      'endPoint': characterName2,
      'descriptionRelation' : descriptionRelation,
    }),
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to update a relation');
  }
}

// call the api to get all characters from the universe 
// except them that are already in the familyTree
Future<List<dynamic>> fetchSearchCharacterToAdd(int universeId, 
String searchCharacter, String familyTreeName) async {
  var universe = await fetchUniverse(universeId);
  var universeName = universe.title;

  // Fetch characters in the family tree
  List<CharacterNode> charactersInFamily = await fetchCharactersFromFamilyTree(familyTreeName);

  // Fetch characters in the universe
  List<dynamic> charactersInUniverse = await fetchCharactersFromUniverse(universeName);

  if  (searchCharacter=='') {
    charactersInUniverse.removeWhere((charactersInUniverse) =>
        charactersInFamily.any((characterInFamily) =>
            characterInFamily.name == charactersInUniverse['name']));
    return charactersInUniverse;
  }

  // call the api to get only the characters who match with the search parameter
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/$universeName/characters/$searchCharacter"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    List<dynamic> charactersInUniverseSearch = jsonDecode(response.body);

    // Remove characters that are already in the family tree from charactersInUniverseSearch
    charactersInUniverseSearch.removeWhere((charactersInUniverseSearch) =>
        charactersInFamily.any((characterInFamily) =>
            characterInFamily.name == charactersInUniverseSearch['name']));
    
    return charactersInUniverseSearch;
  } 
  else {
    throw Exception('Failed to search character(s).');
  }
}

// call the api to get all character from a universe
Future<List<dynamic>> fetchCharactersFromUniverse(String  universeName) async{
  final response = await  http.get(
    Uri.parse("https://localhost:7162/api/universes/$universeName/characters"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );

  if(response.statusCode == 200) {
    List<dynamic> charactersList = jsonDecode(response.body);
    return charactersList;
  } else {
    throw Exception('Failed to load characters from universe.');
  }
}

// call the api to delete a character from a family tree
Future<void> removeCharacterTree(String characterName, String familyTreeName) async {
  final response = await  http.delete(
    Uri.parse("https://localhost:7162/api/families_trees/$familyTreeName/characters/$characterName"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to remove a character');
  }
}

// call the api to delete a relation between two characters
Future<void> removeRelation(String characterName1, String characterName2, String familyTreeName) async {
  final response = await  http.delete(
    Uri.parse("https://localhost:7162/api/families_trees/$familyTreeName/characters/$characterName1/relation/$characterName2"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to remove a relation');
  }
}

// call the api to update a relation between two characters
Future<void> updateRelation(String characterName1, String characterName2, String descriptionRelation, String familyTreeName) async {
  final response = await  http.patch(
    Uri.parse("https://localhost:7162/api/families_trees/$familyTreeName/characters/relation"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, String>{
      'stratPoint': characterName1,
      'endPoint': characterName2,
      'descriptionRelation' : descriptionRelation,
    }),
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to update a relation');
  }
}

// call the api to get characters from the familyTree
Future<List<CharacterNode>> fetchCharactersFromFamilyTree(String familyTreeName) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/families_trees/$familyTreeName/characters"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    List<CharacterNode> characters = [];

    for (var character in jsonResponse) {
      CharacterNode node = CharacterNode(
        character['name'],
        character['children'],
        character['parents'],
        character['married'],
        character['divorced'],
        character['couple'],
        false,
        character['level'],
        false,
      );
      characters.add(node);
    }

    return characters;
  } else {
    throw Exception('Failed to load universe.');
  }
}