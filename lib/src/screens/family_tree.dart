import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../navigation/menu_drawer.dart';
import '../navigation2.0/route_delegate.dart';
import '../model/universe.dart';

class MyFamiliesTree extends StatefulWidget {
  final int universeId;
  const MyFamiliesTree({required this.universeId, super.key});

  @override
  State<MyFamiliesTree> createState() => _MyFamiliesTreeState();
}

class _MyFamiliesTreeState extends State<MyFamiliesTree> {
  late Future<Universe> futureUniverse;
  late Future<List<dynamic>> futureFamiliesTrees;
  late Future<void> futureFamilyTree;

  @override
  void initState() {
    super.initState();
    futureUniverse = fetchUniverse(widget.universeId);
    futureFamiliesTrees = futureUniverse.then((universe) { 
      return fetchFamiliesTrees(universe.title); 
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbre Généalogique'),
      ),
      drawer: MenuDrawer(universeId: widget.universeId,),
      body: Center(
        child: FutureBuilder<List<dynamic>> (
          future: futureFamiliesTrees,
          builder: (context, snapshot) {
            if (snapshot.hasData) 
            { 
              return Wrap(
                spacing: 30, // Espace horizontal entre les carrés
                runSpacing: 25, // Espace vertical entre les lignes de carrés
                children: snapshot.data!.map((familyTree) {
                  return InkWell(
                    onTap: () {
                      (Router.of(context).routerDelegate as MyRouteDelegate)
                          .handleFamilyTreeTapped(widget.universeId, familyTree['name']);
                    },
                    child: Container(
                      width: 200, // Largeur de chaque carré
                      height: 200, // Hauteur de chaque carré
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 17, 119, 124).withOpacity(0.7), // Opacité ajustée
                        borderRadius: BorderRadius.circular(20.0), // Bordures arrondies
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              familyTree['name'],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateFamilyTreeDialog,
        tooltip: 'Nouveau arbre généalogique',
        child: const Icon(Icons.add),
      ),
    );
  }
  // show form for created new character
  Future<void> _showCreateFamilyTreeDialog() async {
    TextEditingController nameController = TextEditingController();

    Universe universe = await futureUniverse;

    if (!mounted) return;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un nouveau arbre généalogique'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nom:'),
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
            TextButton(
              onPressed: () async {
                await createFamilyTree(universe.title, nameController.text);
                // Actualiser la page après la création de l'univers
                setState(() {
                  futureFamiliesTrees = fetchFamiliesTrees(universe.title);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
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

// call to api get all th families trees
Future<List<dynamic>> fetchFamiliesTrees(String universeName) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/$universeName/families_trees"),
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

// call to api create a new family tree
Future<void> createFamilyTree(String universeName, String name) async {
  final response = await  http.post(
    Uri.parse("https://localhost:7162/api/universes/$universeName/families_trees"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, String>{
      'name': name,
    }),
  );
  
  if (response.statusCode  != 200) {
    throw Exception('Failed to create character');
  }
}