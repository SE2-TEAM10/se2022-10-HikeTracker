import 'package:HikeTracker/common/city_input_field/city_input_field.dart';
import 'package:HikeTracker/common/city_input_field/models.dart';
import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/message.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/map_borders.dart';
import 'package:HikeTracker/pages/add_reference_point/models/new_reference.dart';
import 'package:HikeTracker/pages/add_reference_point/widget/add_reference_point_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class AddReferencePoint extends StatefulWidget {
  const AddReferencePoint({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  State<AddReferencePoint> createState() => _AddReferencePoint();
}

class _AddReferencePoint extends State<AddReferencePoint> {
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
      leftFlex: 2,
      rightFlex: 3,
      leftChild: Stack(
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
      rightChild: AddReferencePointForm(
        onSubmit: (
            newReferencePoint,
            ) =>
            onSubmit(
              newReferencePoint: newReferencePoint,
            ),
      ),
    );
  }

  Future<MapBorders> getBorders(City city) async {
    final res = await widget.client.get(api: 'border/${city.id}');
    return MapBorders.fromJson(res.body);
  }

  Future<void> onSubmit({
    required NewReferencePoint newReferencePoint,
  }) async {
    if (selectedCoordinate == null) {
      Message(
        context: context,
        message: 'Select the reference point position from the map',
        messageType: MessageType.Error,
      ).show();
      return;
    }

    //Insert selected coordiantes into the parking
    newReferencePoint = newReferencePoint.copyWith(
      latitude: selectedCoordinate!.latitude.toString(),
      longitude: selectedCoordinate!.longitude.toString(),
      city: selectedCity!.name,
      province: selectedProvince!.name,
    );

    if (newReferencePoint.isFull() == false) {
      Message(
        context: context,
        message: 'Fill all the fields',
      ).show();
      return;
    }

    final res = await widget.client.post(
      body: newReferencePoint.toMap(),
      api: 'addReferencePoint',
    );

    if (res.statusCode == 201) {
      Message(
        context: context,
        message: 'Reference Point added successfully.',
      ).show();
      GoRouter.of(context).pop();
    } else if (res.statusCode == 422) {
      Message(
        context: context,
        message: 'Request error',
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
