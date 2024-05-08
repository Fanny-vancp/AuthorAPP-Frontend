import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../navigation2.0/route_delegate.dart';
import '../navigation2.0/route_config.dart';
import '../model/character_node.dart';
//import '../model/relation_line.dart';-
import '../requestAPI/family_tree.dart';

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
  //late Future<List<dynamic>> futureCharacters;
  late Future<List<CharacterNode>> futureCharacters;
  late Future<List<dynamic>> futureListSearch;
  bool showAddRelation = false;
  bool showUpdateRelation = false;
  bool showDeleteRelation = false;
  late String character1;
  late String character2;

  @override
  void initState() {
    super.initState();
    futureCharacters = fetchCharactersFromFamilyTree(widget.familyTreeName);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.familyTreeName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            (Router.of(context).routerDelegate as MyRouteDelegate).handleRouteChange(RouteConfig.familyTree(widget.universeId));
          },
        ),
      ),
      
      body: Center(
        child: FutureBuilder<List<CharacterNode>>(
          future: futureCharacters,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Visibility(
                    visible: showAddRelation || showUpdateRelation || showDeleteRelation,
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
                                        character.name,
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
                                        character2 = character.name;
                                        _openAddRelationDialog(character1, character2);
                                        showAddRelation = false;
                                      }
                                      else if (showUpdateRelation) {
                                        character2 = character.name;
                                        _openUpdateRelationDialog(character1, character2);
                                        showUpdateRelation = false;
                                      }
                                      else if (showDeleteRelation) {
                                        character2 = character.name;
                                        _openDeleteRelationDialog(character1, character2);
                                        showDeleteRelation = false;
                                      }
                                      else {
                                        showAddRelation = true;
                                        character1 = character.name;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Visibility(
                                  visible: !showAddRelation && !showUpdateRelation &&!showDeleteRelation,
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
                                                      await removeCharacterTree(character.name, widget.familyTreeName);
                                                      Navigator.of(context).pop();
                                                      setState(() {
                                                        futureCharacters = fetchCharactersFromFamilyTree(widget.familyTreeName);
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
                                          if (showUpdateRelation) {
                                            character2 = character.name;
                                            _openUpdateRelationDialog(character1, character2);
                                            showUpdateRelation = false;
                                          }
                                          else {
                                            showUpdateRelation = true;
                                            character1 = character.name;
                                          }
                                        });
                                      }
                                      if (value == 3) {
                                        setState(() {
                                          if (showDeleteRelation) {
                                            character2 = character.name;
                                            _openDeleteRelationDialog(character1, character2);
                                            showDeleteRelation = false;
                                          }
                                          else {
                                            showDeleteRelation = true;
                                            character1 = character.name;
                                          }
                                        });
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
      floatingActionButton: showAddRelation || showUpdateRelation || showDeleteRelation
        ? FloatingActionButton(
            onPressed: () {
              setState(() {
                showAddRelation = false;
                showUpdateRelation = false;
                showDeleteRelation = false;
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
    //String descriptionRelation = ''; 
    //TextEditingController descriptionController = TextEditingController();
    String selectedRelationDescription = 'Parent';
    List<String> relationDescriptions = [
      'Parent',
      'Enfant',
      'Marrié(e)',
      'Divorcé(e)',
      'Conjoint',
      'En couple'
    ];


    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ajouter une relation avec $character1 et $character2"),
          /*content: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description de la relation'),
            onChanged: (value) {
              descriptionRelation = value;
            },
          ),*/
          content: DropdownButton<String>(
            value: selectedRelationDescription,
            onChanged: (newValue) {
              setState(() {
                selectedRelationDescription = newValue.toString();
              });
            },
            items: relationDescriptions.map((String relation) {
              return DropdownMenuItem<String>(
                value: relation,
                child: Text(relation),
              );
            }).toList(),
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
                if (selectedRelationDescription.isNotEmpty) {
                  createRelation(character1, character2, selectedRelationDescription, widget.familyTreeName);
                  Navigator.of(context).pop();
                } else {
                  // Affichez un message d'erreur ou empêchez l'utilisateur de continuer sans sélectionner une relation
                }
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
  Future<void> _openDeleteRelationDialog(String character1, String character2) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Êtes-vous sûr de vouloir supprimer la relation entre $character1 et $character2"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                removeRelation(character1, character2, widget.familyTreeName);
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}

/*class FamilyTreePainter extends CustomPainter{
  final List<CharacterNode> characters;

  FamilyTreePainter(
    this.characters,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final nodePositions = calculateNodePositions(size);
    final relationLines = calculateRelationLines(nodePositions);

    drawLines(canvas, relationLines);
    drawNodes(canvas, nodePositions);
  }

  Map<CharacterNode, Offset> calculateNodePositions(Size size) {
    final Map<CharacterNode, Offset> nodePositions = {};

    // Position initiale du premier personnage
    double startX = size.width / 2;
    double startY = 50.0;

    const double levelSpacing = 150.0; // Espacement vertical entre les niveaux de l'arbre
    const double siblingSpacing = 100.0; // Espacement horizontal entre les frères et sœurs

    // Fonction récursive pour positionner les nœuds de manière récursive
    void positionNodes(CharacterNode node, double x, double y) {
      nodePositions[node] = Offset(x, y);

      // Positionner les enfants
      List<CharacterNode> children = node.children;
      if (children.isNotEmpty) {
        final double totalWidth = siblingSpacing * (children.length - 1);
        double startX = x - totalWidth / 2;
        double childY = y + levelSpacing;

        for (int i = 0; i < children.length; i++) {
          positionNodes(children[i], startX + siblingSpacing * i, childY);
        }
      }
    }

    // Positionner le premier personnage (racine de l'arbre)
    positionNodes(characters.first, startX, startY);

    return nodePositions;
  }

  List<RelationLine> calculateRelationLines(Map<CharacterNode, Offset> nodePositions) {
    final List<RelationLine> relationLines = [];

    // Parcourir chaque personnage pour trouver ses relations et dessiner les lignes correspondantes
    for (final character in nodePositions.keys) {
      for (final child in character.children) {
        // Dessiner une ligne de la position du parent à la position de l'enfant
        relationLines.add(RelationLine(
          start: nodePositions[character]!,
          end: nodePositions[child]!,
        ));
      }
    }

    return relationLines;
  }

  void drawNodes(Canvas canvas, Map<CharacterNode, Offset> nodePositions) {
    final Paint nodePaint = Paint()..color = Colors.blue;
    const double nodeRadius = 20.0;

    // Dessiner chaque personnage comme un cercle à sa position respective
    nodePositions.forEach((character, position) {
      canvas.drawCircle(position, nodeRadius, nodePaint);
    });
  }

  void drawLines(Canvas canvas, List<RelationLine> relationLines) {
    final Paint linePaint = Paint()..color = Colors.black..strokeWidth = 2.0;

    // Dessiner chaque ligne de relation entre les nœuds sur le canvas
    relationLines.forEach((line) {
      canvas.drawLine(line.start, line.end, linePaint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}*/


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
                            await addCharacterTree(character['name'], widget.familyTreeName);
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
/*Future<List<dynamic>> fetchCharactersFromFamilyTree(String familyTreeName) async {
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
}*/

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