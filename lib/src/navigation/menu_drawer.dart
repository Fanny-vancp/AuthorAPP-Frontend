import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_config.dart';
import  '../navigation2.0/route_delegate.dart';

class MenuDrawer extends StatelessWidget {
  /*final Function(String) onMenuItemSelected;

  const MenuDrawer({required this.onMenuItemSelected});*/

  


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

    final MyRouteDelegate routerDelegate = Router.of(context).routerDelegate as MyRouteDelegate;
    
    
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
            case 'Acceuil':
              //('/');
              routerDelegate.handleRouteChange(RouteConfig.home);
              Navigator.pop(context); 
              break;
            case 'Personnages':
              //(':idUniverse/characters');
              routerDelegate.handleRouteChange(RouteConfig.characters);
              Navigator.pop(context);
              break;
            // Handle other menu items similarly
          }
        },
      ));
    });
    return  menuItems;
    
  }
}