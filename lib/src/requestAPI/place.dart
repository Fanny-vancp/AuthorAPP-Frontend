import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/place.dart';

// call the api get place
Future<Place> fetchPlace(int placeId) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/1/places/${placeId.toString()}"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    //Iterable jsonResponse = jsonDecode(response.body);
    Place place = Place.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    return place;
  } else {
    throw Exception('Failed to load universe.');
  }
}

// call to api get all places
Future<List<Place>> fetchPlaces(int idUniverse) async {
  final response = await http.get(
    Uri.parse("https://localhost:7162/api/universes/${idUniverse.toString()}/places"),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if(response.statusCode == 200) {
    Iterable jsonResponse = jsonDecode(response.body);
    List<Place> placesList = jsonResponse.map((model) => Place.fromJson(model)).toList();
    return placesList;
  } else {
    throw Exception('Failed to load universe.');
  }
}

// call to api post place
Future<Place> createPlace(int idUniverse, String name) async {
  final response = await  http.post(
    Uri.parse("https://localhost:7162/api/universes/${idUniverse.toString()}/places/"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, String>{
      'name': name,
    }),
  );

  if (response.statusCode == 201) {
    return Place.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
  else {
    throw Exception('Failed to create character');
  }
}