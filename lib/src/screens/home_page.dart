import 'package:flutter/material.dart';

import '../navigation/menu_drawer.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onShowNextPage; 

  const HomePage({Key? key, required this.onShowNextPage}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home : Choose your universe'),
      ),
      drawer: MenuDrawer(),
    );
  }
}