import 'package:HikeTracker/common/city_input_field/city_input_field.dart';
import 'package:HikeTracker/common/city_input_field/models.dart';
import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/map_borders.dart';
import 'package:HikeTracker/pages/add_parking/widget/add_parking_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:layout/layout.dart';

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
                        onCityChange: (city) async {
                          final b = await getBorders(city);
                          setState(() {
                            mapBorders = b;
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
                newHut,
              ) =>
                  onSubmit(),
              isSmall: context.breakpoint <= LayoutBreakpoint.xs,
            ),
          );
  }

  Future<MapBorders> getBorders(City city) async {
    final res = await widget.client.get(api: 'border/${city.id}');
    return MapBorders.fromJson(res.body);
  }

  Future<void> onSubmit() async {
    if (selectedCoordinate == null) {
      Message(
        context: context,
        message: 'Select the hut position from the map',
        messageType: MessageType.Error,
      ).show();
      return;
    }
  }
}
