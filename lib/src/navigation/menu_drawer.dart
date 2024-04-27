import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_config.dart';
import 'package:http/http.dart' as http;

import  '../navigation2.0/route_delegate.dart';
import '../model/universe.dart';

class MenuDrawer extends StatefulWidget {
  final int universeId;

  const MenuDrawer({required this.universeId, super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  late Future<Universe> futureUniverse;

  @override
  void initState() {
    super.initState();
    futureUniverse = fetchUniverse(widget.universeId);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }

  List<Widget> buildMenuItems(BuildContext context){
    final List<String> menuTitles = [
      'Accueil',
      'Personnages',
      'Arbre généalogique',
      'Lieux',
      'Races',
      'Mythologie & Religion',
      'Lore',
      'Groupes',
      'Livres'
    ];

    final MyRouteDelegate routerDelegate = Router.of(context).routerDelegate as MyRouteDelegate;
    
    
    List<Widget> menuItems = [];
    menuItems.add(DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blueGrey),
      child: FutureBuilder<Universe>(
        future: futureUniverse,
        builder: (context , snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data!.title,
              style: const TextStyle(color: Colors.white, fontSize: 28), // Style applied here
            );
          } else if (snapshot.hasError) { return Text('${snapshot.error}'); }
          return const Text('Loading...');
        },
      ),
    ));

    menuTitles.forEach((title) {
      menuItems.add(ListTile(
        title: Text(title),
        onTap: () {
          // Handle navigation based on title
          switch(title) {
            case 'Accueil':
              //('/home');
              routerDelegate.handleRouteChange(RouteConfig.home());
              break;
            case 'Personnages':
              //('/home/:idUniverse/characters');
              routerDelegate.handleRouteChange(RouteConfig.characters(widget.universeId));
              break;
            case 'Arbre généalogique':
              //('/home/:idUniverse/family_tree');
              routerDelegate.handleRouteChange(RouteConfig.familyTree(widget.universeId));
            case 'Lieux':
              //('/home/:idUniverse/places');
              routerDelegate.handleRouteChange(RouteConfig.places(widget.universeId));
              break;
          }
        },
      ));
    });
    return  menuItems;
    
  }
}

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