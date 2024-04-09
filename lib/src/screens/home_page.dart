import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../navigation/menu_drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home : Choose your universe'),
      ),
      drawer: const MenuDrawer(),
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
                      subtitle: Text(snapshot.data![index].description),
                      // Vous pouvez ajouter d'autres informations de l'univers ici
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
/*
Future<http.Response> fetchUniverses(){
  return  http.get(Uri.parse("https://localhost:7162/api/universes"));
}*/

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
    //return Universe.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load universe.');
  }
}