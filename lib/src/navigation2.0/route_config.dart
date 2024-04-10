//enum RouteConfig {home, universe, characters, unknow}
class RouteConfig {
  final Uri uri;
  final int? idCharacter;

  RouteConfig.home()
    : uri = Uri(path: "/home"),
      idCharacter = null;

  RouteConfig.unknown()
    : uri = Uri(path: "/404"),
      idCharacter = null;

  //RouteConfig.universe({String? id}) -> Todo
  RouteConfig.universe()
    : uri = Uri(path: "/home/universe_name"),
      idCharacter = null;

  RouteConfig.characters()
    : uri = Uri(path: "/home/universe_name/characters"),
      idCharacter = null;

  RouteConfig.characterDetails(this.idCharacter)
    : uri = Uri(path: "/home/universe_name/characters/${idCharacter.toString()}");


  bool get isHomeSection => (uri == RouteConfig.home().uri);
  bool get isUnknowSection => (uri == RouteConfig.unknown().uri);
  bool get isUniverseSection => (uri == RouteConfig.universe().uri);
  bool get isCharactersSection => (uri == RouteConfig.characters().uri);
  bool get isCharacterDetailsSection => (idCharacter != null);

  @override
  String toString() {
    return "RouteConfig{ uriPath : ${uri.path}, idCharacter : ${idCharacter.toString()} }";
  }

  /*@override
  List<Object> get props => [uri.path, idCharacter];*/
}