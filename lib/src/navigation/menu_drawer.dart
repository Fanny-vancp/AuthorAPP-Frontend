import 'package:flutter/material.dart';

import 'go_router.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

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
      'Home',
      'Personnage',
      'Arbre généalogique',
      'Royaume'
    ];
    List<Widget> menuItems = [];
    menuItems.add(const DrawerHeader(
      decoration: BoxDecoration(color: Colors.blueGrey),
      child: Text('Unverse **',
        style: TextStyle(color: Colors.white, fontSize: 28))
    ));

    menuTitles.forEach((title) {
      menuItems.add(ListTile(
        title: Text(title),
        onTap: () {
          // Handle navigation based on title
          switch(title) {
            case 'Home':
              router.go('/');
              break;
            case 'Personnage':
              router.go('/characters');
              break;
            // Handle other menu items similarly
          }
        },
      ));
    });
    return  menuItems;
  }
}