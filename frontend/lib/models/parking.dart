import 'dart:convert';

import 'package:latlong2/latlong.dart';

class Parking {
  Parking({
    required this.id,
    required this.name,
    required this.capacity,
    required this.coordinate,
    required this.city,
    required this.province,
  });

  final int id;
  final String name;
  final int capacity;
  final LatLng coordinate;
  final String city;
  final String province;

  static Parking fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Parking(
      id: res['ID'] ?? 0,
      name: res['name'] ?? 'NA',
      capacity: res['capacity'] ?? 0,
      coordinate: LatLng(res['latitude'] ?? 0, res['longitude'] ?? 0),
      city: res['city'] ?? 'NA',
      province: res['province'] ?? 'NA',
    );
  }
}
