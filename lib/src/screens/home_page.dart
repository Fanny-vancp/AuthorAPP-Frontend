import 'package:flutter/material.dart';

import '../navigation/menu_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your universe'),
      ),
      drawer: const MenuDrawer(),
    );
  }
}