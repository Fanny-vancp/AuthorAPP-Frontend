import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_config.dart';

// convert information URL in configuration route
class MyRouteInformationParser extends RouteInformationParser<RouteConfig> {
  @override
  Future<RouteConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    // -> '/'
    if  (uri.pathSegments.isEmpty) 
      { return RouteConfig.home; }
    //  -> '/:idUniverse'
    else if (uri.pathSegments.length == 1) 
      { return RouteConfig.universe; }
    // -> '/:idUniverse/characters'
    else if (uri.pathSegments.length == 2 && uri.pathSegments[2] == 'characters') 
      { return RouteConfig.characters; }
    // Fallback à home si l'url ne correspond à aucune route connue
    return RouteConfig.home;
  }
}