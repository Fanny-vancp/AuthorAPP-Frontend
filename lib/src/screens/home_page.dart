import 'package:flutter/material.dart';

//import '../navigation/menu_drawer.dart';
import '../navigation2.0/route_delegate.dart';
import '../model/universe.dart';
import '../requestAPI/universe.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisis ton univers'),
      ),
      //drawer: const MenuDrawer(),
      body: Center(
        child: FutureBuilder<List<Universe>> (
          future: futureUniverses,
          builder: (context, snapshot) {
            if (snapshot.hasData) 
            { 
              return Wrap(
                spacing: 30, 
                runSpacing: 25,
                children: snapshot.data!.map((universe) {
                  return InkWell(
                    onTap: () {
                      (Router.of(context).routerDelegate as MyRouteDelegate)
                          .handleUniverseTapped(universe.id);
                    },
                    child: Container(
                      width: 200, 
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 17, 119, 124).withOpacity(0.7), // Opacité ajustée
                        borderRadius: BorderRadius.circular(20.0), // Bordures arrondies
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              universe.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              universe.literaryGenre,
                              style: const TextStyle(
                                color: Colors.white,
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
        onPressed: _showCreateUniverseDialog,
        tooltip: 'Nouveau univers',
        child: const Icon(Icons.add),
      ),
    );
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
}