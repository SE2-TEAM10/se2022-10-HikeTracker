import 'dart:convert';

import 'package:latlong2/latlong.dart';

class MapBorders {
  MapBorders({
    required this.borders,
  });

  final List<List<LatLng>> borders;

  factory MapBorders.fromJson(String jsonString) {
    final result = List<List<LatLng>>.empty(growable: true);
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<dynamic> coordinates = jsonDecode(data['coordinates']);
    coordinates.forEach((e) {
      final x = (e[0] as List).map((c) => LatLng(c[1], c[0])).toList();
      result.add(x);
    });
    return MapBorders(
      borders: result,
    );
  }

  LatLng getCenter() {
    return borders.first.first;
  }
}
