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