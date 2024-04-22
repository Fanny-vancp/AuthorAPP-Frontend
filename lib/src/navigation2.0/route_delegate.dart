import 'package:flutter/material.dart';
import 'package:frontend/src/screens/characters.dart';
import 'package:frontend/src/screens/family_tree.dart';
import 'package:frontend/src/screens/home_page.dart';
import 'package:frontend/src/screens/place_details.dart';
import 'package:frontend/src/screens/places.dart';
import 'package:frontend/src/screens/universe_home_page.dart';
import 'package:frontend/src/screens/unknown_screen.dart';
import 'package:frontend/src/screens/character_details.dart';
//import '../model/character.dart';
import 'route_config.dart';

class MyRouteDelegate extends RouterDelegate<RouteConfig>  with ChangeNotifier, 
  PopNavigatorRouterDelegateMixin<RouteConfig> {
    RouteConfig _configuration = RouteConfig.home(); // -> .home = '/'

    @override
    RouteConfig? get currentConfiguration => _configuration;

    void handleRouteChange(RouteConfig newConfig){
      _configuration = newConfig;
      notifyListeners(); // notify the router of the update
    }

    @override
    GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

    @override
    Widget build(BuildContext context) {
      return Navigator(
        key: navigatorKey, // get by PopNavigatorRouterDelegateMixin
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          // return to the home page when a page is take off
          //handleRouteChange(RouteConfig.home());
          notifyListeners();
          return true;
        },
        pages: [
          const MaterialPage(
            child: HomePage(),
          ),
          /*if (_configuration.uri == RouteConfig.universe(_configuration.idUniverse).uri) 
            MaterialPage(child: MyUniverse(universeId: _configuration.idUniverse!)),
          if ( _configuration.uri == RouteConfig.characters(_configuration.idUniverse).uri)
            MaterialPage(child: AllCharacters(universeId: _configuration.idUniverse!)),
          if ( _configuration.uri == RouteConfig.characterDetails(_configuration.idUniverse, 
          _configuration.idCharacter).uri)
            MaterialPage(child: CharacterDetails(characterId: _configuration.idCharacter!,)),
          if ( _configuration.uri == RouteConfig.places(_configuration.idUniverse).uri)
            MaterialPage(child: AllPlaces(universeId: _configuration.idUniverse!)),
          if ( _configuration.uri == RouteConfig.placeDetails(_configuration.idUniverse, 
          _configuration.idPlace).uri)
            MaterialPage(child: PlaceDetails(placeId: _configuration.idPlace!,)),
          if (_configuration.uri == RouteConfig.unknown().uri) 
            const MaterialPage(child: UnknowScreen()),*/
          if (_configuration.isHomeSection)
            const MaterialPage(child: HomePage()),
          if (_configuration.isUniverseSection)
            MaterialPage(child: MyUniverse(universeId: _configuration.idUniverse!)),
          if (_configuration.isCharactersSection)
            MaterialPage(child: AllCharacters(universeId: _configuration.idUniverse!)),
          if (_configuration.isCharacterDetailsSection)
            MaterialPage(child: CharacterDetails(characterId: _configuration.idCharacter!,)),
          if (_configuration.isPlacesSection)
            MaterialPage(child: AllPlaces(universeId: _configuration.idUniverse!)),
          if (_configuration.isPlaceDetailsSection)
            MaterialPage(child: PlaceDetails(placeId: _configuration.idPlace!,)),
          if (_configuration.isFamilyTreeSection)
            MaterialPage(child: MyFamiliesTree(universeId: _configuration.idUniverse!)),
          if (_configuration.isUnknowSection)
            const MaterialPage(child: UnknowScreen()),
        ],
      );
    }

    @override
    Future<void> setNewRoutePath(RouteConfig configuration) async {
      _configuration = configuration;
    }

    void handleCharacterTapped(int universeId, int characterId) {
      _configuration = RouteConfig.characterDetails(universeId, characterId);
      notifyListeners();
    }

    void handleUniverseTapped(int universeId) {
      _configuration = RouteConfig.universe(universeId);
      notifyListeners();
    }

    void handlePlaceTapped(int universeId, int placeId) async {
      _configuration = RouteConfig.placeDetails(universeId, placeId);
      notifyListeners();
    }
}