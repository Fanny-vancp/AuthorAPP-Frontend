import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_config.dart';

// convert information URL in configuration route
class MyRouteInformationParser extends RouteInformationParser<RouteConfig> {
  @override
  Future<RouteConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final Uri uri = routeInformation.uri;
      //  -> '/home' && '/'
    if (uri.pathSegments.isEmpty || 
      (uri.pathSegments.length == 1 && uri.pathSegments[0] == RouteConfig.home().uri.pathSegments[0]))
      { return RouteConfig.home(); }
    //  -> '/home/:universeName'
    else if (uri.pathSegments.length == 2 && uri.pathSegments[0] == RouteConfig.universe().uri.pathSegments[0]
      && uri.pathSegments[1] == RouteConfig.universe().uri.pathSegments[1]) 
      { return RouteConfig.universe(); }
    // -> '/home/:universeName/characters'
    else if (uri.pathSegments.length == 3 && uri.pathSegments[0] == RouteConfig.characters().uri.pathSegments[0] 
      && uri.pathSegments[1] == RouteConfig.characters().uri.pathSegments[1] && uri.pathSegments[2] == RouteConfig.characters().uri.pathSegments[2]) 
      { return RouteConfig.characters(); }
    // Fallback à home si l'url ne correspond à aucune route connue
    return RouteConfig.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(RouteConfig path) {
    if (path.isUnknowSection) {
      return RouteInformation(location: RouteConfig.unknown().uri.path);
    }
    if (path.isHomeSection) {
      return RouteInformation(location: RouteConfig.home().uri.path);
    }
    if (path.isUniverseSection) {
      return RouteInformation(location: RouteConfig.universe().uri.path);
    }
    if (path.isCharactersSection) {
      return RouteInformation(location: RouteConfig.characters().uri.path);
    }
    return  RouteInformation(location: "");
  }

}