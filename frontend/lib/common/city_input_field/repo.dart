import 'package:HikeTracker/common/city_input_field/models.dart';
import 'package:HikeTracker/utils/rest_client.dart';

class CityInputFieldRepo {
  CityInputFieldRepo({
    required this.client,
  });
  final RestClient client;

  Future<List<Region>> getRegions() async {
    final res = await client.get(
      api: 'regions',
    );
    return Region.fromJsonList(res.body);
  }

  Future<List<Province>> getProvinces(int regionId) async {
    final res = await client.get(
      api: 'provinces/$regionId',
    );
    return Province.fromJsonList(res.body);
  }

  Future<List<City>> getCities(int provinceId) async {
    final res = await client.get(
      api: 'municipalities/$provinceId',
    );
    return City.fromJsonList(res.body);
  }
}
