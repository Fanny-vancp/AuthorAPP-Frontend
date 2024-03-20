import 'package:flutter/material.dart';

import '../navigation/menu_drawer.dart';

class AllCharacters extends StatelessWidget {
  const AllCharacters({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters of the universe **'),
      ),
      drawer: const MenuDrawer(),
    );
  }
}