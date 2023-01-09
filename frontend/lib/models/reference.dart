import 'dart:convert';

import 'package:latlong2/latlong.dart';

class ReferencePoint {
  ReferencePoint({
    required this.id,
    required this.name,
    required this.type,
    required this.coordinate,
    required this.city,
    required this.province,
  });

  final int id;
  final String name;
  final String type;
  final LatLng coordinate;
  final String city;
  final String province;

  static ReferencePoint fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return ReferencePoint(
      id: res['ID'] ?? 0,
      name: res['name'] ?? 'NA',
      type: res['type'] ?? 0,
      coordinate: LatLng(res['latitude'] ?? 0, res['longitude'] ?? 0),
      city: res['city'] ?? 'NA',
      province: res['province'] ?? 'NA',
    );
  }
}
