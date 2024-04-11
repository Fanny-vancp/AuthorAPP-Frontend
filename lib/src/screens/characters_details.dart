import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/character.dart';
import '../navigation2.0/route_delegate.dart';
import '../navigation2.0/route_config.dart';

class CharacterDetails extends StatefulWidget {
  final int characterId;

  const CharacterDetails({
    required this.characterId, 
    super.key
  });

  @override
  State<CharacterDetails> createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails> {
  late Future<Character> futureCharacter;
  late int characterId;

  @override
  void initState() {
    super.initState();
    futureCharacter = fetchCharacter(widget.characterId);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Character>(
          future: futureCharacter,
          builder: (context , snapshot) {
            if (snapshot.hasData) {
              characterId = snapshot.data!.idUniverse;
              return Text(snapshot.data!.name);
            } else if (snapshot.hasError) { return Text('${snapshot.error}'); }
            return const Text('Loading...');
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            (Router.of(context).routerDelegate as MyRouteDelegate).handleRouteChange(RouteConfig.characters(characterId));
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<Character>(
          future: futureCharacter,
          builder: (context , snapshot) {
            if (snapshot.hasData){ return CharacterCard(character: snapshot.data!); }
            else if (snapshot.hasError) { return Text('${snapshot.error}'); }

            // by default, show a loading spinner
            return const  CircularProgressIndicator();
          }
        )
      )
    );
  }
}

// UI character card
class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({required this.character, super.key,
});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              character.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${character.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Gender: ${character.gender}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Eye Color: ${character.eyeColor}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Hair Color: ${character.hairColor}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


// call the api
Future<Character> fetchCharacter(int characterId) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/1/characters/${characterId.toString()}"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    //Iterable jsonResponse = jsonDecode(response.body);
    Character character = Character.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return character;
  } else {
    throw Exception('Failed to load universe.');
  }
}
