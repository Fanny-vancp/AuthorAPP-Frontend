import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/place.dart';
import '../navigation2.0/route_delegate.dart';
import '../navigation2.0/route_config.dart';

class PlaceDetails extends StatefulWidget {
  final int placeId;
  const PlaceDetails({required this.placeId, super.key});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  late Future<Place> futurePlace;
  late int placeId;

  @override
  void initState() {
    super.initState();
    futurePlace = fetchPlace(widget.placeId);
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Place>(
          future: futurePlace,
          builder: (context , snapshot) {
            if (snapshot.hasData) {
              placeId = snapshot.data!.idUniverse;
              return Text(snapshot.data!.name);
            } else if (snapshot.hasError) { return Text('${snapshot.error}'); }
            return const Text('Loading...');
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            (Router.of(context).routerDelegate as MyRouteDelegate).handleRouteChange(RouteConfig.places(placeId));
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<Place>(
          future: futurePlace,
          builder: (context , snapshot) {
            if (snapshot.hasData){ return PlaceCard(place: snapshot.data!); }
            else if (snapshot.hasError) { return Text('${snapshot.error}'); }

            // by default, show a loading spinner
            return const  CircularProgressIndicator();
          }
        )
      )
    );
  }
}

// UI place card
class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({required this.place, super.key,});

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
              place.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nombre de population: ${place.numberOfPeople}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Description historique: ${place.descriptionHistoric}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Races associés: ${place.associatedRaces}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

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