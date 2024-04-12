import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_config.dart';
import  '../navigation2.0/route_delegate.dart';

class MenuDrawer extends StatelessWidget {
  final int universeId;

  const MenuDrawer({required this.universeId, super.key});
  

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
            case 'Accueil':
              //('/home');
              routerDelegate.handleRouteChange(RouteConfig.home());
              break;
            case 'Personnages':
              //('/home/:idUniverse/characters');
              routerDelegate.handleRouteChange(RouteConfig.characters(universeId));
              break;
            case 'Lieux':
              //('/home/:idUniverse/places');
              routerDelegate.handleRouteChange(RouteConfig.places(universeId));
              break;
          }
        },
      ));
    });
    return  menuItems;
    
  }
}