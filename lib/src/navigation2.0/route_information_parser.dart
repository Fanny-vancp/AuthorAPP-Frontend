import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_config.dart';

// convert information URL in configuration route
class MyRouteInformationParser extends RouteInformationParser<RouteConfig> {
  @override
  Future<RouteConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final Uri uri = routeInformation.uri;
      //  -> '/home' && '/'
    if (uri.pathSegments.isEmpty || 
      (uri.pathSegments.length == 1 
        && uri.pathSegments[0] == RouteConfig.home().uri.pathSegments[0]))
    { return RouteConfig.home(); }
    //  -> '/home/:universeId'
    else if (uri.pathSegments.length == 2 
        && uri.pathSegments[0] == RouteConfig.home().uri.pathSegments[0]) 
    { 
      var universeId = int.tryParse(uri.pathSegments[1]);
      return RouteConfig.universe(universeId); 
    }
    // -> '/home/:universeId/characters'
    else if (uri.pathSegments.length == 3 
        && uri.pathSegments[0] == RouteConfig.home().uri.pathSegments[0] 
        && uri.pathSegments[2] == 'characters' ) 
    { 
      var universeId = int.tryParse(uri.pathSegments[1]);
      return RouteConfig.characters(universeId); 
    }
    // -> '/home/:universeId/characters/:characterId'
    else if (uri.pathSegments.length == 4 
        && uri.pathSegments[0] == RouteConfig.home().uri.pathSegments[0] 
        && uri.pathSegments[2] == 'characters' ) {
      var universeId = int.tryParse(uri.pathSegments[1]);
      var  characterId = int.tryParse(uri.pathSegments[3]);
      if  (characterId == null) return RouteConfig.unknown();
      return RouteConfig.characterDetails(universeId, characterId);
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
      return RouteInformation(uri: Uri.parse(RouteConfig.universe(configuration.idUniverse).uri.path));
    }
    if (configuration.isCharactersSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.characters(configuration.idUniverse).uri.path));
    }
    if (configuration.isCharacterDetailsSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.characterDetails(configuration.idUniverse, configuration.idCharacter).uri.path));
    }
    return RouteInformation(uri: Uri.parse(""));
  }

}