import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import '../navigation/menu_drawer.dart';
import '../navigation2.0/route_delegate.dart';
import '../model/universe.dart';

class HomePage extends StatefulWidget {
  /*final VoidCallback onShowNextPage; 
  const HomePage({Key? key, required this.onShowNextPage}) : super(key: key);*/
  const HomePage ({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Universe>> futureUniverses;

  @override
  void initState() {
    super.initState();
    futureUniverses = fetchUniverses();
  }

  // show form for created new universe
  Future<void> _showCreateUniverseDialog() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController genreController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un nouvel univers'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                ),
                TextField(
                  controller: genreController,
                  decoration: const InputDecoration(labelText: 'Genre littéraire'),
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
                await createUniverse(titleController.text, genreController.text);
                // Actualiser la page après la création de l'univers
                setState(() {
                  futureUniverses = fetchUniverses();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home : Choose your universe'),
      ),
      //drawer: const MenuDrawer(),
      body: Center(
        child: FutureBuilder<List<Universe>> (
          future: futureUniverses,
          builder: (context, snapshot) {
            if (snapshot.hasData) 
            { 
              //return Text(snapshot.data!.title); 
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text(snapshot.data![index].literaryGenre),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        //onPressed: onShowCharacterDetails,
                        onPressed: () {
                          (Router.of(context).routerDelegate as MyRouteDelegate).handleUniverseTapped(snapshot.data![index].id);
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
        onPressed: _showCreateUniverseDialog,
        tooltip: 'Nouveau univers',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<Universe> createUniverse(String title, String genre) async {
  final response = await  http.post(
    Uri.parse("https://localhost:7162/api/universes"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'literaryGenre': genre,
    }),
  );

  if (response.statusCode == 201) {
    return Universe.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
  else {
    throw Exception('Failed to create universe');
  }
}


Future<List<Universe>> fetchUniverses() async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    List<Universe> universesList = jsonResponse.map((model) => Universe.fromJson(model)).toList();
    return universesList;
  } else {
    throw Exception('Failed to load universe.');
  }
}