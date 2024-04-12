class Place {
  final int id;
  final int idUniverse;
  final String name;
  final int numberOfPeople;
  final String descriptionHistoric;
  final String associatedRaces;

  Place({
    required this.id,
    required this.idUniverse,
    required this.name,
    required this.numberOfPeople,
    required this.descriptionHistoric,
    required this.associatedRaces,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      idUniverse: json['idUniverse'] as int,
      name: json['name'] as String,
      numberOfPeople: json['numberOfPeople'] != null ? json['numberOfPeople'] as int : 0,
      descriptionHistoric: json['descriptionHistoric'] != null ? json['descriptionHistoric'] as String : '',
      associatedRaces: json['associatedRaces'] != null ? json['associatedRaces'] as String : '',
    );
  }
}