class NewReferencePoint {
  NewReferencePoint({
    this.name,
    this.city,
    this.type,
    this.hike_ID,
    this.province,
    this.latitude,
    this.longitude,
  });

  final String? name;
  final String? type;
  final String? city;
  late final String? hike_ID;
  final String? province;
  final String? latitude;
  final String? longitude;

  Map<String, dynamic> toMap() => {
    'name': name,
    'type': type,
    'hike_id': hike_ID,
    'latitude': double.parse(latitude!),
    'longitude': double.parse(longitude!),
    'city': city,
    'province': province,
  };

  bool isFull() =>
      name != null &&
          city != null &&
          hike_ID != null &&
          province != null &&
          type != null &&
          latitude != null &&
          longitude != null;

  NewReferencePoint copyWith({
    String? name,
    String? type,
    String? hike_ID,
    String? city,
    String? province,
    String? latitude,
    String? longitude,
  }) =>
      NewReferencePoint(
        name: name ?? this.name,
        city: city ?? this.city,
        hike_ID: hike_ID ?? this.hike_ID,
        province: province ?? this.province,
        type: type ?? this.type,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
