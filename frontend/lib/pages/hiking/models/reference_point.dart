import 'dart:convert';

class ReferencePoint {
  ReferencePoint({
    required this.id,
    required this.name,
    required this.type,
  });

  final int id;
  final String type;
  final String name;

  static ReferencePoint fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return ReferencePoint(
      id: res['ref_ID'] ?? 0,
      name: res['name'] ?? 'NA',
      type: res['ref_type'] ?? 'NA',
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
