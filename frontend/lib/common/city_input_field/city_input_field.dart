import 'package:HikeTracker/common/autocomplete_input_field.dart';
import 'package:HikeTracker/common/city_input_field/models.dart';
import 'package:HikeTracker/common/city_input_field/repo.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';

class CityInputField extends StatefulWidget {
  const CityInputField({
    required this.client,
    this.onRegionChange,
    this.onProvinceChange,
    this.onCityChange,
    super.key,
  });

  final RestClient client;
  final void Function(Region)? onRegionChange;
  final void Function(Province)? onProvinceChange;
  final void Function(City)? onCityChange;

  @override
  State<CityInputField> createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  late CityInputFieldRepo repo;

  List<Region>? regionsList;
  List<Province>? provincesList;
  List<City>? citiesList;

  Region? region;
  Province? province;
  City? city;

  @override
  void initState() {
    repo = CityInputFieldRepo(client: widget.client);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final res = await repo.getRegions();
      setState(() {
        regionsList = res;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutocompleteInputField(
          label: 'Region',
          disabled: regionsList == null,
          items: regionsList
              ?.map((e) => AutocompleteItem(value: e.id, label: e.name))
              .toList(),
          onSelect: (item) async {
            setState(() {
              region = regionsList!.firstWhere((e) => e.id == item.value);
            });
            widget.onRegionChange?.call(region!);
            final res = await repo.getProvinces(region!.id);
            setState(() {
              provincesList = res;
            });
          },
        ),
        AutocompleteInputField(
          label: 'Province',
          items: provincesList
              ?.map((e) => AutocompleteItem(value: e.id, label: e.name))
              .toList(),
          disabled: provincesList == null,
          onSelect: (item) async {
            setState(() {
              province = provincesList!.firstWhere((e) => e.id == item.value);
            });
            widget.onProvinceChange?.call(province!);
            final res = await repo.getCities(province!.id);
            setState(() {
              citiesList = res;
            });
          },
        ),
        AutocompleteInputField(
          label: 'City',
          items: citiesList
              ?.map((e) => AutocompleteItem(value: e.id, label: e.name))
              .toList(),
          disabled: citiesList == null,
          onSelect: (item) async {
            setState(() {
              city = citiesList!.firstWhere((e) => e.id == item.value);
            });
            widget.onCityChange?.call(city!);
          },
        ),
      ],
    );
  }
}
