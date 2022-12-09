class NewParking {
  NewParking({
    this.name,
    this.city,
    this.capacity,
    this.province,
    this.latitude,
    this.longitude,
  });

  final String? name;
  final int? capacity;
  final String? city;
  final String? province;
  final String? latitude;
  final String? longitude;

  Map<String, dynamic> toMap() => {
        'name': name,
        'capacity': capacity,
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'province': province,
      };

  NewParking copyWith({
    String? name,
    String? capacity,
    String? city,
    String? province,
    String? latitude,
    String? longitude,
  }) =>
      NewParking(
        name: name ?? this.name,
        city: city ?? this.city,
        province: province ?? this.province,
        capacity: capacity != null ? int.parse(capacity) : this.capacity,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
