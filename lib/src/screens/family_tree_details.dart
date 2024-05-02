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
  bool showAddRelation = false;
  bool showUpdateRelation = false;
  late String character1;
  late String character2;

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
        child: FutureBuilder<List<dynamic>>(
          future: futureCharacters,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Visibility(
                    visible: showAddRelation || showUpdateRelation,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Choisissez un autre personnage',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 25,
                      children: snapshot.data!.map((character) {
                        return InkWell(
                          child: Stack(
                            children: [
                              Container(
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
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      if (showAddRelation) {
                                        character2 = character['name'];
                                        _openAddRelationDialog(character1, character2);
                                        showAddRelation = false;
                                      }
                                      else if (showUpdateRelation) {
                                        character2 = character['name'];
                                        _openUpdateRelationDialog(character1, character2);
                                        showUpdateRelation = false;
                                      }
                                      else {
                                        showAddRelation = true;
                                        character1 = character['name'];
                                      }
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Visibility(
                                  visible: !showAddRelation && !showUpdateRelation,
                                  child: PopupMenuButton(
                                    icon: const Icon(Icons.more_vert),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Text("Supprimer le character")
                                      ),
                                      const PopupMenuItem(
                                        value: 2,
                                        child: Text("Changer une relation"),
                                      ),
                                      const PopupMenuItem(
                                        value: 3,
                                        child: Text("Supprimer une relation"),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 1) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirmation"),
                                              content: const Text("Êtes-vous sûr de vouloir supprimer ce personnage ?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Annuler"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      await removeCharacter(character['name'], widget.familyTreeName);
                                                      Navigator.of(context).pop();
                                                      setState(() {
                                                        futureCharacters = fetchCharacters(widget.familyTreeName);
                                                      });
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Personnage supprimé avec succès")));
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur lors de la suppression du personnage")));
                                                    }
                                                  },
                                                  child: const Text("Confirmer"),
                                                ),
                                              ],
                                            );
                                          }
                                        );
                                      }
                                      if (value == 2) {
                                          setState(() {
                                            if (!showAddRelation){
                                              if (showUpdateRelation) {
                                                character2 = character['name'];
                                                _openUpdateRelationDialog(character1, character2);
                                                showUpdateRelation = false;
                                              }
                                              else {
                                                showUpdateRelation = true;
                                                character1 = character['name'];
                                              }
                                            }
                                          });

                                      }
                                      if (value == 3) {
                                        
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
            else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: showAddRelation || showUpdateRelation
        ? FloatingActionButton(
            onPressed: () {
              setState(() {
                showAddRelation = false;
                showUpdateRelation = false;
              });
            },
            tooltip: 'Annuler',
            child: const Icon(Icons.close),
          )
        : FloatingActionButton(
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
            tooltip: 'Ajouter un personnage',
            child: const Icon(Icons.add),
          ),
    );
  }

  Future<void> _openAddRelationDialog(String character1, String character2) async {
    String descriptionRelation = ''; 
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ajouter une relation avec $character1 et $character2"),
          content: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description de la relation'),
            onChanged: (value) {
              descriptionRelation = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                createRelation(character1, character2, descriptionRelation, widget.familyTreeName);
                Navigator.of(context).pop();
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _openUpdateRelationDialog(String character1, String character2) async {
    String descriptionRelation = ''; 
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modifier la relation entre $character1 et $character2"),
          content: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description de la relation'),
            onChanged: (value) {
              descriptionRelation = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                updateRelation(character1, character2, descriptionRelation, widget.familyTreeName);
                Navigator.of(context).pop();
              },
              child: const Text('Mofier'),
            ),
          ],
        );
      },
    );
  }
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
      'endPoint': familyTreeName,
      'descriptionRelation' : '',
    }),
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to add a character');
  }
}


// call the api to delete a character from a family tree
Future<void> removeCharacter(String characterName, String familyTreeName) async {
  final response = await  http.delete(
    Uri.parse("https://localhost:7162/api/families_trees/${familyTreeName}/characters/${characterName}"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to remove a character');
  }
}

// call the api to create a relation between two characters
Future<void> createRelation(String characterName1, String characterName2, String descriptionRelation, String familyTreeName) async {
  final response = await  http.post(
    Uri.parse("https://localhost:7162/api/families_trees/${familyTreeName}/characters/relation"),
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

// call the api to delete a relation between two characters

// call the api to update a relation between two characters
Future<void> updateRelation(String characterName1, String characterName2, String descriptionRelation, String familyTreeName) async {
  final response = await  http.patch(
    Uri.parse("https://localhost:7162/api/families_trees/${familyTreeName}/characters/relation"),
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
