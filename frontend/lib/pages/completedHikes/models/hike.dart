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
    required this.start_time,
    required this.end_time,
    required this.coverUrl,
    required this.userId,
  });

  final int id;
  final String name;
  final int length;
  final String expectedTime;
  final int ascent;
  final String difficulty;
  final String description;
  final String coverUrl;
  final String start_time;
  final String end_time;
  final int userId;

  static Hike fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Hike(
      id: res['ID'] ?? 0,
      name: res['name'] ?? 'NA',
      length: res['length'] ?? 0,
      expectedTime: res['expected_time'] ?? 'NA',
      ascent: res['ascent'] ?? 0,
      difficulty: res['difficulty'] ?? 'NA',
      description: res['description'] ?? 'NA',
      start_time: res['start_time'] ?? 'NA',
      end_time: res['end_time'] ?? 'NA',
      coverUrl: res['coverUrl'] ?? 'NA',
      userId: res['userID'] ?? 0,
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

