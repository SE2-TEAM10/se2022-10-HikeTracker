import 'package:HikeTracker/common/city_input_field/city_input_field.dart';
import 'package:HikeTracker/common/city_input_field/models.dart';
import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/map_borders.dart';
import 'package:HikeTracker/pages/add_hut/models/new_hut.dart';
import 'package:HikeTracker/pages/add_hut/widget/add_hut_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:layout/layout.dart';

import '../../common/message.dart';

class AddHut extends StatefulWidget {
  const AddHut({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  State<AddHut> createState() => _AddHutState();
}

class _AddHutState extends State<AddHut> {
  bool isLoading = false;
  LatLng? selectedCoordinate;
  MapBorders? mapBorders;
  Province? selectedProvince;
  City? selectedCity;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : TwoColumnsLayout(
            leftChild: Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: MapBanner(
                      client: widget.client,
                      mapBorders: mapBorders,
                      onTap: (value) {
                        setState(() {
                          selectedCoordinate = value;
                        });
                      },
                      selectedCoordinates: selectedCoordinate != null
                          ? [selectedCoordinate!]
                          : null,
                    ),
                  ),
                  Positioned(
                    top: 32,
                    left: 32,
                    right: 32,
                    child: Card(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: CityInputField(
                        client: widget.client,
                        onProvinceChange: (province) => {
                          setState(() {
                            selectedProvince = province;
                          })
                        },
                        onCityChange: (city) async {
                          final b = await getBorders(city);
                          setState(() {
                            mapBorders = b;
                          });
                          setState(() {
                            selectedCity = city;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            rightChild: AddHutForm(
              onSubmit: (
                newHut,
              ) =>
                  onSubmit(
                newHut: newHut,
              ),
              isSmall: context.breakpoint <= LayoutBreakpoint.xs,
            ),
          );
  }

  Future<MapBorders> getBorders(City city) async {
    final res = await widget.client.get(api: 'border/${city.id}');
    return MapBorders.fromJson(res.body);
  }

  Future<void> onSubmit({
    required NewHut newHut,
  }) async {
    if (selectedCoordinate == null) {
      Message(
        context: context,
        message: 'Select the hut position from the map',
        messageType: MessageType.Error,
      ).show();
      return;
    }

    //Insert selected coordiantes into the hut
    newHut = newHut.copyWith(
      latitude: selectedCoordinate!.latitude.toString(),
      longitude: selectedCoordinate!.longitude.toString(),
      city: selectedCity!.name,
      province: selectedProvince!.name,
    );

    final res = await widget.client.post(
      body: newHut.toMap(),
      api: 'addHut',
    );

    if (res.statusCode == 201) {
      Message(
        context: context,
        message: 'Hut added successfully.',
      ).show();
      GoRouter.of(context).pop();
    } else if (res.statusCode == 422) {
      Message(
        context: context,
        message: res.body,
        messageType: MessageType.Error,
      ).show();
    } else {
      Message(
        context: context,
        message: res.body,
        messageType: MessageType.Error,
      ).show();
    }
  }
}
