import 'package:flutter/material.dart';

import '../navigation/menu_drawer.dart';

class MyFamiliesTree extends StatelessWidget {
  final int universeId;
  const MyFamiliesTree({required this.universeId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbre Généalogique'),
      ),
      drawer: MenuDrawer(universeId: universeId,),
    );
  }
}