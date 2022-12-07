import 'dart:convert';

class Region {
  Region({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Region.fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Region(
      id: res['ID'],
      name: res['name'],
    );
  }

  static List<Region> fromJsonList(String jsonString) {
    final List<dynamic> res = jsonDecode(jsonString);

    return res
        .map(
          (e) => Region(
            id: e['ID'],
            name: e['name'],
          ),
        )
        .toList();
  }
}

class Province {
  Province({
    required this.id,
    required this.name,
    required this.regionId,
  });

  final int id;
  final String name;
  final int regionId;

  factory Province.fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return Province(
      id: res['ID'],
      name: res['name'],
      regionId: res['region_ID'],
    );
  }

  static List<Province> fromJsonList(String jsonString) {
    final List<dynamic> res = jsonDecode(jsonString);

    return res
        .map(
          (e) => Province(
            id: e['ID'],
            name: e['name'],
            regionId: e['region_ID'],
          ),
        )
        .toList();
  }
}

class City {
  City({
    required this.id,
    required this.name,
    required this.provinceId,
  });

  final int id;
  final String name;
  final int provinceId;

  factory City.fromJson(String jsonString) {
    final res = jsonDecode(jsonString);

    return City(
      id: res['ID'],
      name: res['name'],
      provinceId: res['province_ID'],
    );
  }

  static List<City> fromJsonList(String jsonString) {
    final List<dynamic> res = jsonDecode(jsonString);

    return res
        .map(
          (e) => City(
            id: e['ID'],
            name: e['name'],
            provinceId: e['province_ID'],
          ),
        )
        .toList();
  }
}
