import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../navigation/menu_drawer.dart';
import '../model/universe.dart';

class MyUniverse extends StatefulWidget {
  final int universeId;

  const MyUniverse({required this.universeId, super.key});

  @override
  State<MyUniverse> createState() => _MyUniverseState();
}

class _MyUniverseState extends State<MyUniverse> {
  late Future<Universe> futureUniverse;

  @override
  void initState() {
    super.initState();
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
              return Text(snapshot.data!.title);
            } else if (snapshot.hasError) { return Text('${snapshot.error}'); }
            return const Text('Loading...');
          }, 
        ),
      ),
      drawer: MenuDrawer(universeId: widget.universeId,),
      body: const Center(
        
      ),
    );
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