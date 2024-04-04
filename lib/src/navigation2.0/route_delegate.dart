import 'package:flutter/material.dart';
import 'package:frontend/src/screens/characters.dart';
import 'package:frontend/src/screens/home_page.dart';
import 'package:frontend/src/screens/universes.dart';
import 'route_config.dart';

class MyRouteDelegate extends RouterDelegate<RouteConfig>  with ChangeNotifier, 
  PopNavigatorRouterDelegateMixin<RouteConfig> {
    RouteConfig _configuration = RouteConfig.home; // -> .home = '/'
    //RouteConfig _previousConfiguration = _configuration;

    //List<String> universesFromDB = ['Keleana','Acotar'];

    @override
    RouteConfig? get currentConfiguration => _configuration;

    void handleRouteChange(RouteConfig newConfig){
      _configuration = newConfig;
      notifyListeners(); // notify the router of the update
    }

    @override
    Widget build(BuildContext context) {
      return Navigator(
        key: navigatorKey, // get by PopNavigatorRouterDelegateMixin
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          // return to the home page when a page is take off
          handleRouteChange(RouteConfig.home);
          return true;
        },
        pages: [
          MaterialPage(
            child: HomePage(
              onShowNextPage: () => handleRouteChange(RouteConfig.universe),
            ),
          ),
          if (_configuration == RouteConfig.universe) 
            const MaterialPage(child: MyUniverse()),
          if (_configuration == RouteConfig.characters) 
            const MaterialPage(child: AllCharacters()),
        ],
      );
    }

    @override
    GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

    @override
    Future<void> setNewRoutePath(RouteConfig configuration) async {
      _configuration = configuration;
    }
}