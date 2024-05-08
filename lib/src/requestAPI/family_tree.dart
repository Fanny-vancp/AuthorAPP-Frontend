import 'dart:convert';

import 'package:http/http.dart' as http;

import '../requestAPI/universe.dart';
import '../screens/family_tree_details.dart';

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
  List<dynamic> charactersInFamily = await fetchCharactersFromFamilyTree(familyTreeName);

  if  (searchCharacter=='') {
    return charactersInFamily;
  }

  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/$universeName/characters/$searchCharacter"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    List<dynamic> charactersInUniverse = jsonDecode(response.body);

    // Remove characters that are already in the family tree from charactersInUniverse
    charactersInUniverse.removeWhere((characterInUniverse) =>
        charactersInFamily.any((characterInFamily) =>
            characterInFamily['name'] == characterInUniverse['name']));
    
    return charactersInUniverse;
  } 
  else {
    throw Exception('Failed to search character(s).');
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