/*
import 'dart:convert';

class Hut {
  Hut({
    required this.id,
    required this.name,
    required this.description,
    required this.openingtime,
    required this.closingtime,
    required this.bednum,
    required this.altitude,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.province,
    required this.phone,
    required this.mail,
    required this.website,
  });

  final int id;
  final String name;
  final String description;
  final String openingtime;
  final int bednum;
  final String closingtime;
  final int altitude;
  final double latitude;
  final double longitude;
  final String city;
  final String province;
  final String phone;
  final String mail;
  final String website;

  static Hut fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Hut(
      id: res['ID'] ?? 0,
      name: res['name'] ?? 'NA',
      description: res['description'] ?? 'NA',
      openingtime: res['opening_time'] ?? 'NA',
      bednum: res['bed_num'] ?? 0,
      closingtime: res['closing_time'] ?? 'NA',
      city: res['city'] ?? 'NA',
      latitude: res['latitude'] ?? 0.0,
      longitude: res['longitude'] ?? 0.0,
      altitude: res['altitude'] ?? 0,
      province: res['province'] ?? 'NA',
      phone: res['phone'] ?? 'NA',
      mail: res['mail'] ?? 'NA',
      website: res['website'] ?? 'NA',
    );
  }
/*
  String formatTime() {
    final parts = expectedTime.split(':');
    return '${parts[0]}h ${parts[1]}m';
  }
  */
}

class Huts {
  Huts({
    this.results,
  });

  final List<Hut>? results;

  static Huts fromJson(String jsonString) {
    final res = jsonDecode(jsonString);
    final results = res as List<dynamic>;

    final result = Huts(
      results: results.map((p) {
        return Hut.fromJson(
          json.encode(p),
        );
      }).toList(),
    );

    return result;
  }
}
*/