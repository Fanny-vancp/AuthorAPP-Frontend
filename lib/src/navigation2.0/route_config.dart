//enum RouteConfig {home, universe, characters, unknow}
class RouteConfig {
  final Uri uri;

  RouteConfig.home()
    : uri = Uri(path: "/home");

  RouteConfig.unknown()
    : uri = Uri(path: "/404");

  //RouteConfig.universe({String? id}) -> Todo
  RouteConfig.universe()
    : uri = Uri(path: "/home/universe_name");

  RouteConfig.characters()
    : uri = Uri(path: "/home/universe_name/characters");

  //RouteConfig.characters({String? id}) -> Todo 

  bool get isHomeSection => (uri == RouteConfig.home().uri);
  bool get isUnknowSection => (uri == RouteConfig.unknown().uri);
  bool get isUniverseSection => (uri == RouteConfig.universe().uri);
  bool get isCharactersSection => (uri == RouteConfig.characters().uri);

  @override
  String toString() {
    return "RouteConfig{ uriPath : "+ uri.path +"}";
  }
}