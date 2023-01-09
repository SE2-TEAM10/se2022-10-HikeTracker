import 'dart:convert';

class ReferencePoint {
  ReferencePoint({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.state,
  });

  final int id;
  final String type;
  final String name;
  final String city;
  final bool state;

  static ReferencePoint fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return ReferencePoint(
      id: res['ref_ID'] ?? 0,
      name: res['name'] ?? 'NA',
      type: res['type'] ?? 'NA',
      city: res['city'] ?? 'NA',
      state: res['state'] == 0 ? false : true,
    );
  }
/*
  String formatTime() {
    final parts = expectedTime.split(':');
    return '${parts[0]}h ${parts[1]}m';
  }
  */
}

class ReferencePoints {
  ReferencePoints({
    this.results,
  });

  final List<ReferencePoint>? results;

  static ReferencePoints fromJson(String jsonString) {
    final res = jsonDecode(jsonString);
    final results = res as List<dynamic>;

    final result = ReferencePoints(
      results: results.map((p) {
        return ReferencePoint.fromJson(
          json.encode(p),
        );
      }).toList(),
    );

    return result;
  }
}
