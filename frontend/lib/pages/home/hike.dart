import 'dart:convert';

class Hike {
  Hike({
    required this.id,
    required this.name,
    required this.length,
    required this.expectedTime,
    required this.ascent,
    required this.difficulty,
    required this.startPoint,
    required this.endPoint,
    required this.description,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.province,
    required this.hikeID,
  });

  final int id;
  final String name;
  final int length;
  final String expectedTime;
  final int ascent;
  final String difficulty;
  final String startPoint;
  final String endPoint;
  final String description;
  final String locationName;
  final String latitude;
  final String longitude;
  final String city;
  final String province;
  final int hikeID;

  static Hike fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Hike(
      id: res['id'] ?? 0,
      name: res['name'] ?? 'NA',
      length: res['length'] ?? 0,
      expectedTime: res['expected_time'] ?? 'NA',
      ascent: res['ascent'] ?? 0,
      difficulty: res['difficulty'] ?? 'NA',
      startPoint: res['start_point'] ?? 'NA',
      endPoint: res['end_point'] ?? 'NA',
      description: res['description'] ?? 'NA',
      locationName: res['location_name'] ?? 'NA',
      latitude: res['latitude'] ?? 'NA',
      longitude: res['longitude'] ?? 'NA',
      city: res['city'] ?? 'NA',
      province: res['province'] ?? 'NA',
      hikeID: res['hike_ID'] ?? 0,
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
