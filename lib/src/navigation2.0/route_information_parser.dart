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
        && uri.pathSegments[2] == 'characters' ) 
    {
      var universeId = int.tryParse(uri.pathSegments[1]);
      var  characterId = int.tryParse(uri.pathSegments[3]);
      if  (characterId == null) return RouteConfig.unknown();
      return RouteConfig.characterDetails(universeId, characterId);
    }
    // -> '/home/:idUniverse/places'
    else if (uri.pathSegments.length == 3 
        && uri.pathSegments[0] == RouteConfig.home().uri.pathSegments[0] 
        && uri.pathSegments[2] == 'places' ) 
    { 
      var universeId = int.tryParse(uri.pathSegments[1]);
      return RouteConfig.places(universeId); 
    }
    // -> '/home/:universeId/places/:placeId'
    else if (uri.pathSegments.length == 4 
        && uri.pathSegments[0] == RouteConfig.home().uri.pathSegments[0] 
        && uri.pathSegments[2] == 'places' ) 
    {
      var universeId = int.tryParse(uri.pathSegments[1]);
      var  placeId = int.tryParse(uri.pathSegments[3]);
      if  (placeId == null) return RouteConfig.unknown();
      return RouteConfig.placeDetails(universeId, placeId);
    }
    // -> '/home/:universeId/family_tree'
    else if (uri.pathSegments.length == 3
        && uri.pathSegments[0] == RouteConfig.home().uri.pathSegments[0] 
        && uri.pathSegments[2] == 'family_tree')
    {
      var universeId = int.tryParse(uri.pathSegments[1]);
      return RouteConfig.familyTree(universeId); 
    }
    // Fallback à home if url doesn't correspond to any route
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
    if (configuration.isPlacesSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.places(configuration.idUniverse).uri.path));
    }
    if (configuration.isPlaceDetailsSection) {
      return RouteInformation(uri: Uri.parse(RouteConfig.placeDetails(configuration.idUniverse, configuration.idPlace).uri.path));
    }
    if (configuration.isFamilyTreeSection) {
      return RouteInformation(uri:Uri.parse(RouteConfig.familyTree(configuration.idUniverse).uri.path));
    }
    return RouteInformation(uri: Uri.parse(""));
  }

}