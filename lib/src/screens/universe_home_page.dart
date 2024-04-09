import 'package:flutter/material.dart';

import '../navigation/menu_drawer.dart';

class MyUniverse extends StatelessWidget {
  const MyUniverse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenu dans *:universe_name*'),
      ),
      drawer: const MenuDrawer(),
      body: const Center(
        
      ),
    );
  }
}