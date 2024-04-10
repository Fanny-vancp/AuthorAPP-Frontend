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
    else if (uri.pathSegments.length == 3 && uri.pathSegments[2] == RouteConfig.characters().uri.pathSegments[2] 
      && uri.pathSegments[1] == RouteConfig.characters().uri.pathSegments[1] && uri.pathSegments[2] == RouteConfig.characters().uri.pathSegments[2]) 
      { return RouteConfig.characters(); }
    // -> '/home/:universeName/characters/:characterId'
    else if (uri.pathSegments.length == 4 && uri.pathSegments[2] == RouteConfig.characters().uri.pathSegments[2] ) {
      var remaining = uri.pathSegments[3];
      var  characterId = int.tryParse(remaining);
      if  (characterId == null) return RouteConfig.unknown();
      return RouteConfig.characterDetails(characterId);
    }
    
    // Fallback à home si l'url ne correspond à aucune route connue
    return RouteConfig.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(RouteConfig configuration) {
    if (configuration.isUnknowSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.unknown().uri.path));
    }
    if (configuration.isHomeSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.home().uri.path));
    }
    if (configuration.isUniverseSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.universe().uri.path));
    }
    if (configuration.isCharactersSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.characters().uri.path));
    }
    if (configuration.isCharacterDetailsSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.characterDetails(configuration.idCharacter).uri.path));
    }
    return RouteInformation(uri: Uri.parse(""));
  }

}