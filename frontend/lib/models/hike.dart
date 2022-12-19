import 'dart:convert';

import 'package:flutter/material.dart';

class Hike {
  Hike({
    required this.id,
    required this.name,
    required this.length,
    required this.expectedTime,
    required this.ascent,
    required this.difficulty,
    required this.description,
    required this.locations,
    required this.coverUrl,
  });

  final int id;
  final String name;
  final int length;
  final String expectedTime;
  final int ascent;
  final String difficulty;
  final String description;
  final List<Location> locations;
  final String coverUrl;

  static Hike fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    final ls = List<Location>.from(
      res['location']
          .map((e) => e != null ? Location.fromJson(json.encode(e)) : null)
          .toList()
          .whereType<Location>(),
    );

    return Hike(
      id: res['ID'] ?? 0,
      name: res['name'] ?? 'NA',
      length: res['length'] ?? 0,
      expectedTime: res['expected_time'] ?? 'NA',
      ascent: res['ascent'] ?? 0,
      difficulty: res['difficulty'] ?? 'NA',
      description: res['description'] ?? 'NA',
      locations: ls,
      coverUrl: res['coverUrl'] ?? 'NA',
    );
  }

  String formatTime() {
    final parts = expectedTime.split(':');
    return '${parts[0]}h ${parts[1]}m';
  }

  String formatDifficulty() {
    switch (difficulty) {
      case 'T':
        return 'Turistic';
      case 'H':
        return 'Hiking';
      case 'PH':
        return 'Professional';
      default:
        return 'Turistic';
    }
  }

  Color difficultyColor(BuildContext context) {
    switch (difficulty) {
      case 'T':
        return Theme.of(context).colorScheme.primaryContainer;
      case 'H':
        return Theme.of(context).colorScheme.tertiaryContainer;
      case 'PH':
        return Theme.of(context).colorScheme.errorContainer;
      default:
        return Theme.of(context).colorScheme.primaryContainer;
    }
  }

  Color difficultyTextColor(BuildContext context) {
    switch (difficulty) {
      case 'T':
        return Theme.of(context).colorScheme.onPrimaryContainer;
      case 'H':
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case 'PH':
        return Theme.of(context).colorScheme.onErrorContainer;
      default:
        return Theme.of(context).colorScheme.onPrimaryContainer;
    }
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

    final result = Hikes(
      results: results.map((p) {
        return Hike.fromJson(
          json.encode(p),
        );
      }).toList(),
    );

    return result;
  }
}

class Location {
  Location({
    this.name = 'Undefined',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.city = 'NA',
    this.province = 'NA',
  });

  String name;
  double latitude;
  double longitude;
  String city;
  String province;

  static Location fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Location(
      name: res['name'],
      latitude: (res['latitude'] as num).toDouble(),
      longitude: (res['longitude'] as num).toDouble(),
      city: res['city'],
      province: res['province'],
    );
  }
}
