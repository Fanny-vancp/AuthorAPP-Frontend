import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_delegate.dart';
import 'package:http/http.dart' as http;

import '../navigation/menu_drawer.dart';
import '../model/character.dart';
import '../model/universe.dart';

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
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].description),
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
      )
    );
  }
}

Future<List<Character>> fetchCharacters(int idUniverse) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/${idUniverse.toString()}/characters"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    List<Character> charactersList = jsonResponse.map((model) => Character.fromJson(model)).toList();
    return charactersList;
  } else {
    throw Exception('Failed to load universe.');
  }
}

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