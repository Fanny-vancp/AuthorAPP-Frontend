import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_delegate.dart';

import '../navigation/menu_drawer.dart';
import '../model/character.dart';
import '../model/universe.dart';
import '../requestAPI/character.dart';
import '../requestAPI/universe.dart';

class AllCharacters extends StatefulWidget {
  final int universeId;
  const AllCharacters ({required this.universeId, super.key});

  @override
  State<AllCharacters> createState() => _AllCharactersState();
}

class _AllCharactersState extends State<AllCharacters> {
  late Future<List<Character>> futureCharacters;
  late Future<Universe> futureUniverse;

  @override
  void initState() {
    super.initState();
    futureCharacters = fetchCharacters(widget.universeId);
    futureUniverse = fetchUniverse(widget.universeId);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Universe>(
          future: futureUniverse,
          builder: (context , snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data!.title} : Personnage');
            } else if (snapshot.hasError) { return Text('${snapshot.error}'); }
            return const Text('Loading...');
          }, 
        ),
      ),
      drawer: MenuDrawer(universeId: widget.universeId,),
      body: Center(
        child: FutureBuilder<List<Character>> (
          future: futureCharacters,
          builder: (context, snapshot) {
            if (snapshot.hasData) 
            { 
              //return Text(snapshot.data!.title); 
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].pseudo),
                      subtitle: Text(snapshot.data![index].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        //onPressed: onShowCharacterDetails,
                        onPressed: () {
                          (Router.of(context).routerDelegate as MyRouteDelegate).handleCharacterTapped( widget.universeId, snapshot.data![index].id);
                        }
                      ),
                    ),
                  );
                },
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
        onPressed: _showCreateCharacterDialog,
        tooltip: 'Nouveau personnage',
        child: const Icon(Icons.add),
      ),
    );
  }

  // show form for created new character
  Future<void> _showCreateCharacterDialog() async {
    TextEditingController pseudoController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un nouveau personnage'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: pseudoController,
                  decoration: const InputDecoration(labelText: 'Pseudo:'),
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
                await createCharacter(widget.universeId, pseudoController.text);
                // Actualiser la page après la création de l'univers
                setState(() {
                  futureCharacters = fetchCharacters(widget.universeId);
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