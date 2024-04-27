import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:frontend/src/navigation/menu_drawer.dart';
import 'package:http/http.dart' as http;

import '../model/universe.dart';

class MyFamilyTreeDetails extends StatefulWidget {
  final String familyTreeName;
  final int universeId;

  const MyFamilyTreeDetails({
    required this.familyTreeName,
    required this.universeId,
    super.key});

  @override
  State<MyFamilyTreeDetails> createState() => _MyFamilyTreeDetailsState();
}

class _MyFamilyTreeDetailsState extends State<MyFamilyTreeDetails> {
  late Future<List<dynamic>> futureCharacters;
  late Future<List<dynamic>> futureListSearch;

  @override
  void initState() {
    super.initState();
    futureCharacters = fetchCharacters(widget.familyTreeName);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.familyTreeName),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>> (
          future: futureCharacters,
          builder: (context, snapshot) {
            if (snapshot.hasData) 
            { 
              return Wrap(
                spacing: 30, 
                runSpacing: 25,
                children: snapshot.data!.map((character) {
                  return InkWell(
                    child: Container(
                      width: 200, 
                      height: 200, 
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 215, 156).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              character['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
            else if (snapshot.hasError) 
            { return Text('${snapshot.error}'); }

            // By default, show a loading spinner
            return  const CircularProgressIndicator();
          }
        ) 
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Ajouter un personnage',
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _AddCharacterDialog(
                universeId: widget.universeId,
                familyTreeName: widget.familyTreeName,
              );
            },
          );
        },
      ),
    );
  }

  /*
  // show form for adding new character
  Future<void> _showAddCharacterDialog() async {  
    TextEditingController searchController = TextEditingController();
    Future<List<dynamic>> searchCharacter;

    return showDialog(context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choisis ton personnage à ajouter"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(labelText: "Recherche"),
                ),
              ],
            )
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
          ]
        );
      }
    );
  }*/
}

class _AddCharacterDialog extends StatefulWidget {
  final int universeId;
  final String familyTreeName;

  const _AddCharacterDialog({
    required this.universeId,
    required this.familyTreeName,
  });

  @override
  _AddCharacterDialogState createState() => _AddCharacterDialogState();
}

class _AddCharacterDialogState extends State<_AddCharacterDialog> {
  TextEditingController searchController = TextEditingController(text: '');
  late Future<List<dynamic>> searchResults;

  @override
  void initState() {
    super.initState();
    searchResults = fetchSearchCharacterToAdd(widget.universeId, searchController.text, widget.familyTreeName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choisis ton personnage à ajouter"),
      content: SizedBox(
        width: double.maxFinite, // Utilisation de la largeur maximale disponible
        height: 300, // Taille prédéfinie
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: "Recherche"),
                onChanged: (value) {
                setState(() {
                  searchResults = fetchSearchCharacterToAdd(widget.universeId, value, widget.familyTreeName);
                  //print(searchResults);
                });
              },
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: searchResults,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final List<dynamic> characters = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        dynamic character = characters[index];
                        return ListTile(
                          title: Text(character['name']),
                          onTap: () async {
                            await addCharacter(character['name'], widget.familyTreeName);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}

// call the api to get characters from the familyTree
Future<List<dynamic>> fetchCharacters(String familyTreeName) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/families_trees/${familyTreeName}/characters"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load universe.');
  }
}


// call the api to get all characters from the universe 
// except them that are already in the familyTree
Future<List<dynamic>> fetchSearchCharacterToAdd(int universeId, 
String searchCharacter, String familyTreeName) async {
  var universe = await fetchUniverse(universeId);
  var universeName = universe.title;

  // Fetch characters in the family tree
  List<dynamic> charactersInFamily = await fetchCharacters(familyTreeName);

  if  (searchCharacter=='') {
    return charactersInFamily;
  }

  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/${universeName}/characters/${searchCharacter}"),
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

// call to api get universe
Future<Universe> fetchUniverse(int idUniverse) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/${idUniverse.toString()}"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    Universe universe = Universe.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return universe;
  } else {
    throw Exception('Failed to load universe.');
  }
}


// call the api to add a character in the family tree
Future<void> addCharacter(String characterName, String familyTreeName) async {
  final response = await  http.post(
    Uri.parse("https://localhost:7162/api/families_trees/${familyTreeName}/characters"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, String>{
      'stratPoint': characterName,
      'endPoint': familyTreeName
    }),
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to add a character');
  }
}


// call the api to delete a character from a family tree

// call the api to create a relation between two characters

// call the api to delete a relation between two characters

// call the api to update a relation between two characters

