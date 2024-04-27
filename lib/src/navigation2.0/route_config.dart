//enum RouteConfig {home, universe, characters, unknow}
class RouteConfig {
  final Uri uri;
  final int? idUniverse;
  final int? idCharacter;
  final int? idPlace;
  final String? nameFamilyTree;

  RouteConfig.home()
    : uri = Uri(path: "/home"),
      idUniverse = null,
      idCharacter = null,
      idPlace = null,
      nameFamilyTree = null;

  RouteConfig.unknown()
    : uri = Uri(path: "/404"),
      idUniverse = null,
      idCharacter = null,
      idPlace = null,
      nameFamilyTree = null;

  RouteConfig.universe(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}"),
      idCharacter = null,
      idPlace = null,
      nameFamilyTree = null;

  RouteConfig.characters(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}/characters"),
      idCharacter = null,
      idPlace = null,
      nameFamilyTree = null;

  RouteConfig.characterDetails(this.idUniverse, this.idCharacter)
    : uri = Uri(path: "/home/${idUniverse.toString()}/characters/${idCharacter.toString()}"),
      idPlace = null,
      nameFamilyTree = null;

  RouteConfig.places(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}/places"),
      idCharacter = null,
      idPlace = null, 
      nameFamilyTree = null;

  RouteConfig.placeDetails(this.idUniverse, this.idPlace)
    : uri = Uri(path: "/home/${idUniverse.toString()}/places/${idPlace.toString()}"),
      idCharacter = null,
      nameFamilyTree = null;

  RouteConfig.familyTree(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}/family_tree"),
      idCharacter = null,
      idPlace = null,
      nameFamilyTree = null;

  RouteConfig.familyTreeDetails(this.idUniverse, this.nameFamilyTree)
    : uri = Uri(path: "/home/${idUniverse.toString()}/family_tree/${nameFamilyTree!}"),
      idCharacter = null,
      idPlace = null;


  bool get isHomeSection => 
    (uri == RouteConfig.home().uri);
  bool get isUnknowSection => 
    (uri == RouteConfig.unknown().uri);
  bool get isUniverseSection => 
    (idUniverse != null 
    && idCharacter == null 
    && idPlace == null 
    && uri.path.endsWith(idUniverse.toString()));
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
  bool get isFamilyTreeSection => (
    idUniverse != null 
    && uri.path.endsWith('/family_tree'));
  bool get isFamilyTreeDetailsSection => (
    nameFamilyTree != null
  );


  @override
  String toString() {
    return "RouteConfig{ uriPath : ${uri.path},idUniverse: ${idUniverse.toString()}, idCharacter : ${idCharacter.toString()} }";
  }

  /*
  @override
  List<Object> get props => [uri.path, idUniverse!, idCharacter!, idPlace!];*/
}