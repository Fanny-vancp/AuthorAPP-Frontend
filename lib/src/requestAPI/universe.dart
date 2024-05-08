import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/universe.dart';

// call to api get universe
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

// call to api get all Universes
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

// call to api post new universe
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