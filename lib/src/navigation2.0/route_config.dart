//enum RouteConfig {home, universe, characters, unknow}
class RouteConfig {
  final Uri uri;
  final int? idUniverse;
  final int? idCharacter;

  RouteConfig.home()
    : uri = Uri(path: "/home"),
      idUniverse = null,
      idCharacter = null;

  RouteConfig.unknown()
    : uri = Uri(path: "/404"),
      idUniverse = null,
      idCharacter = null;

  RouteConfig.universe(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}"),
      idCharacter = null;

  RouteConfig.characters(this.idUniverse)
    : uri = Uri(path: "/home/${idUniverse.toString()}/characters"),
      idCharacter = null;

  RouteConfig.characterDetails(this.idUniverse, this.idCharacter)
    : uri = Uri(path: "/home/${idUniverse.toString()}/characters/${idCharacter.toString()}");


  bool get isHomeSection => (uri == RouteConfig.home().uri);
  bool get isUnknowSection => (uri == RouteConfig.unknown().uri);
  bool get isUniverseSection => (idUniverse != null && idCharacter == null);
  bool get isCharactersSection =>
      (idUniverse != null && idCharacter == null && uri.path.endsWith('/characters'));
  bool get isCharacterDetailsSection => (idCharacter != null);

  @override
  String toString() {
    return "RouteConfig{ uriPath : ${uri.path},idUniverse: ${idUniverse.toString()}, idCharacter : ${idCharacter.toString()} }";
  }

  /*@override
  List<Object> get props => [uri.path, idCharacter];*/
}