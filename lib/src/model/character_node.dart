class CharacterNode {
  final String name;
  // final String image;
  final List<dynamic> children;
  final List<dynamic> parents;
  final List<dynamic> married;
  final List<dynamic> divorced;
  final List<dynamic> couple;
  final bool isShow;
  final bool isDone;
  final int level;

  CharacterNode(
    this.name, 
    this.children,
    this.parents,
    this.married,
    this.divorced,
    this.couple,
    this.isShow,
    this.level,
    this.isDone,
  );
}