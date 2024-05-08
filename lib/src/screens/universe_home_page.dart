import 'package:flutter/material.dart';

import '../navigation/menu_drawer.dart';
import '../model/universe.dart';
import '../requestAPI/universe.dart';

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