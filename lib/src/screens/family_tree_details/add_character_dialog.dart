import 'package:flutter/material.dart';

import '../../requestAPI/family_tree.dart';

class AddCharacterDialog extends StatefulWidget {
  final int universeId;
  final String familyTreeName;

  const AddCharacterDialog({
    required this.universeId,
    required this.familyTreeName,
    super.key
  });

  @override
  AddCharacterDialogState createState() => AddCharacterDialogState();
}

class AddCharacterDialogState extends State<AddCharacterDialog> {
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