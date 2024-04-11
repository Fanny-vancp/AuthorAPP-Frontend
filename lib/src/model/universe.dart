class Universe {
  final int id;
  final String title;
  final String literaryGenre;

  Universe({
    required this.id,
    required this.title,
    required this.literaryGenre,
  });

  factory Universe.fromJson(Map<String, dynamic> json) {
    return Universe(
      id: json['id'] as int,
      title: json['title'] as String,
      literaryGenre: json['literaryGenre'] as String,
    );
  }
}