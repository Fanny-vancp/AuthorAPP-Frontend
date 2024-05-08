import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_delegate.dart';

import '../navigation/menu_drawer.dart';
import '../model/place.dart';
import '../model/universe.dart';
import '../requestAPI/place.dart';
import '../requestAPI/universe.dart';

class AllPlaces extends StatefulWidget {
  final int universeId;
  const AllPlaces ({required this.universeId, super.key});

  @override
  State<AllPlaces> createState() => _AllPlacesState();
}

class _AllPlacesState extends State<AllPlaces> {
  late Future<List<Place>> futurePlaces;
  late Future<Universe> futureUniverse;

  @override
  void initState() {
    super.initState();
    futurePlaces = fetchPlaces(widget.universeId);
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
              return Text('${snapshot.data!.title} : Lieu');
            } else if (snapshot.hasError) { return Text('${snapshot.error}'); }
            return const Text('Loading...');
          }, 
        ),
      ),
      drawer: MenuDrawer(universeId: widget.universeId,),
      body: Center(
        child: FutureBuilder<List<Place>> (
          future: futurePlaces,
          builder: (context, snapshot) {
            if (snapshot.hasData) 
            { 
              //return Text(snapshot.data!.title); 
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Text('Races associés : ${snapshot.data![index].associatedRaces}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        //onPressed: onShowCharacterDetails,
                        onPressed: () {
                          (Router.of(context).routerDelegate as MyRouteDelegate).handlePlaceTapped( widget.universeId, snapshot.data![index].id);
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
        onPressed: _showCreatePlaceDialog,
        tooltip: 'Nouveau lieu',
        child: const Icon(Icons.add),
      ),
    );
  }

  // show form for created new place
  Future<void> _showCreatePlaceDialog() async {
    TextEditingController nameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un nouveau lieu'),
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
                await createPlace(widget.universeId, nameController.text);
                // Actualiser la page après la création de l'univers
                setState(() {
                  futurePlaces = fetchPlaces(widget.universeId);
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