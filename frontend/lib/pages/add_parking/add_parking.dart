import 'package:HikeTracker/common/city_input_field/city_input_field.dart';
import 'package:HikeTracker/common/city_input_field/models.dart';
import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/map_borders.dart';
import 'package:HikeTracker/pages/add_parking/models/new_parking.dart';
import 'package:HikeTracker/pages/add_parking/widget/add_parking_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:layout/layout.dart';
import 'package:go_router/go_router.dart';

import '../../common/message.dart';

class AddParking extends StatefulWidget {
  const AddParking({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  State<AddParking> createState() => _AddParkingState();
}

class _AddParkingState extends State<AddParking> {
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
            rightChild: AddParkingForm(
              onSubmit: (
                newParking,
              ) =>
                  onSubmit(
                newParking: newParking,
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
    required NewParking newParking,
  }) async {
    if (selectedCoordinate == null) {
      Message(
        context: context,
        message: 'Select the parking position from the map',
        messageType: MessageType.Error,
      ).show();
      return;
    }

    //Insert selected coordiantes into the parking
    newParking = newParking.copyWith(
      latitude: selectedCoordinate!.latitude.toString(),
      longitude: selectedCoordinate!.longitude.toString(),
      city: selectedCity!.name,
      province: selectedProvince!.name,
    );

    final res = await widget.client.post(
      body: newParking.toMap(),
      api: 'addParking',
    );

    if (res.statusCode == 201) {
      Message(
        context: context,
        message: 'Parking added successfully.',
      ).show();
      GoRouter.of(context).pop();
    } else if (res.statusCode == 422) {
      Message(
        context: context,
        message: 'Gpx file error.',
        messageType: MessageType.Error,
      ).show();
    } else {
      Message(
        context: context,
        message: 'Internal error.',
        messageType: MessageType.Error,
      ).show();
    }
  }
}
