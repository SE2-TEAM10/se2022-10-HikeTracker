class NewHike {
  NewHike({
    this.name,
    this.hh,
    this.mm,
    this.difficulty,
    this.description,
    this.startp,
    this.endp,
    this.gpx,
  });

  final String? name;
  final String? hh;
  final String? mm;
  final String? difficulty;
  final String? description;
  final String? gpx;
  final NewLocation? startp;
  final NewLocation? endp;

  Map<String, dynamic> toMap() => {
        'hike': {
          'name': name,
          'expected_time': '$hh:$mm',
          'difficulty': difficulty,
          'description': description,
        },
        'gpx': gpx,
        'startp': startp?.toMap(),
        'endp': endp?.toMap(),
      };

  bool isFull() =>
      name != null &&
      hh != null &&
      mm != null &&
      difficulty != null &&
      description != null &&
      startp != null &&
      startp!.isFull() &&
      endp != null &&
      endp!.isFull() &&
      gpx != null;

  NewHike copyWith({
    String? name,
    String? hh,
    String? mm,
    String? difficulty,
    String? description,
    String? gpx,
    NewLocation? startp,
    NewLocation? endp,
  }) =>
      NewHike(
        name: name ?? this.name,
        hh: hh ?? this.hh,
        mm: mm ?? this.mm,
        difficulty: difficulty ?? this.difficulty,
        description: description ?? this.description,
        gpx: gpx ?? this.gpx,
        startp: startp ?? this.startp,
        endp: endp ?? this.endp,
      );
}

class NewLocation {
  NewLocation({
    this.name,
    this.city,
    this.province,
  });

  final String? name;
  final String? city;
  final String? province;

  Map<String, dynamic> toMap() => {
        'location_name': name,
        'city': city,
        'province': province,
      };

  bool isFull() => name != null && city != null && province != null;

  NewLocation copyWith({
    String? name,
    String? city,
    String? province,
  }) =>
      NewLocation(
        name: name ?? this.name,
        city: city ?? this.city,
        province: province ?? this.province,
      );
}
