//enum RouteConfig {home, universe, characters, unknow}
class RouteConfig {
  final Uri uri;
  final int? idUniverse;
  final int? idCharacter;
  final int? idPlace;

  RouteConfig.home()
    : uri = Uri(path: "/home"),
      idUniverse = null,
      idCharacter = null,
      idPlace = null;

  RouteConfig.unknown()
    : uri = Uri(path: "/404"),
      idUniverse = null,
      idCharacter = null,
      idPlace = null;

  RouteConfig.universe(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}"),
      idCharacter = null,
      idPlace = null;

  RouteConfig.characters(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}/characters"),
      idCharacter = null,
      idPlace = null;

  RouteConfig.characterDetails(this.idUniverse, this.idCharacter)
    : uri = Uri(path: "/home/${idUniverse.toString()}/characters/${idCharacter.toString()}"),
      idPlace = null;

  RouteConfig.places(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}/places"),
      idCharacter = null,
      idPlace = null;

  RouteConfig.placeDetails(this.idUniverse, this.idPlace)
    : uri = Uri(path: "/home/${idUniverse.toString()}/places/${idPlace.toString()}"),
      idCharacter = null;


  bool get isHomeSection => 
    (uri == RouteConfig.home().uri);
  bool get isUnknowSection => 
    (uri == RouteConfig.unknown().uri);
  bool get isUniverseSection => 
    (idUniverse != null 
    && idCharacter == null 
    && idPlace == null);
  bool get isCharactersSection =>
    (idUniverse != null 
    && idCharacter == null 
    && idPlace == null 
    && uri.path.endsWith('/characters'));
  bool get isCharacterDetailsSection => 
    (idCharacter != null 
    && idPlace == null);
  bool get isPlacesSection => 
    (idUniverse != null 
    && idCharacter == null 
    && uri.path.endsWith('/places'));
  bool get isPlaceDetailsSection => 
    (idPlace != null 
    && idCharacter == null);


  @override
  String toString() {
    return "RouteConfig{ uriPath : ${uri.path},idUniverse: ${idUniverse.toString()}, idCharacter : ${idCharacter.toString()} }";
  }

  /*@override
  List<Object> get props => [uri.path, idCharacter];*/
}