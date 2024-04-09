import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../navigation/menu_drawer.dart';
import '../model/character.dart';

class AllCharacters extends StatefulWidget {
  const AllCharacters({super.key});

  @override
  State<AllCharacters> createState() => _AllCharactersState();
}

class _AllCharactersState extends State<AllCharacters> {
  late Future<List<Character>> futureCharacters;

  @override
  void initState() {
    super.initState();
    futureCharacters = fetchCharacters();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters : Characters of the universe **'),
      ),
      drawer: const MenuDrawer(),
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

Future<List<Character>> fetchCharacters() async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/1/characters"),
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