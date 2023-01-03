class NewReferencePoint {
  NewReferencePoint({
    this.name,
    this.city,
    this.type,
    this.province,
    this.latitude,
    this.longitude,
  });

  final String? name;
  final String? type;
  final String? city;
  final String? province;
  final String? latitude;
  final String? longitude;

  Map<String, dynamic> toMap() => {
    'name': name,
    'type': type,
    'latitude': double.parse(latitude!),
    'longitude': double.parse(longitude!),
    'city': city,
    'province': province,
  };

  bool isFull() =>
      name != null &&
          city != null &&
          province != null &&
          type != null &&
          latitude != null &&
          longitude != null;

  NewReferencePoint copyWith({
    String? name,
    String? type,
    String? city,
    String? province,
    String? latitude,
    String? longitude,
  }) =>
      NewReferencePoint(
        name: name ?? this.name,
        city: city ?? this.city,
        province: province ?? this.province,
        type: type ?? this.type,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
