import 'dart:convert';

class Hike {
  Hike({
    required this.id,
    required this.name,
    required this.length,
    required this.expected_time,
    required this.ascent,
    required this.difficulty,
    required this.start_point,
    required this.end_point,
    required this.description,
    required this.location_name,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.province,
    required this.hike_ID,
  });

  final int id;
  final String name;
  final int length;
  final String expected_time;
  final int ascent;
  final String difficulty;
  final String start_point;
  final String end_point;
  final String description;
  final String location_name;
  final String latitude;
  final String longitude;
  final String city;
  final String province;
  final int hike_ID;

  static Hike fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Hike(
      id: res['id'] ?? 0,
      name: res['name'] ?? 'NA',
      length: res['length'] ?? 0,
      expected_time: res['expected_time'] ?? 'NA',
      ascent: res['ascent'] ?? 0,
      difficulty: res['difficulty'] ?? 'NA',
      start_point: res['start_point'] ?? 'NA',
      end_point: res['end_point'] ?? 'NA',
      description: res['description'] ?? 'NA',
      location_name: res['location_name'] ?? 'NA',
      latitude: res['latitude'] ?? 'NA',
      longitude: res['longitude'] ?? 'NA',
      city: res['city'] ?? 'NA',
      province: res['province'] ?? 'NA',
      hike_ID: res['hike_ID'] ?? 0,
    );
  }
}

class Hikes {
  Hikes({
    this.results,
  });

  final List<Hike>? results;

  static Hikes fromJson(String jsonString) {
    final res = jsonDecode(jsonString);
    final results = res as List<dynamic>;

    return Hikes(
      results: results.map((p) {
        return Hike.fromJson(
          json.encode(p),
        );
      }).toList(),
    );
  }
}
