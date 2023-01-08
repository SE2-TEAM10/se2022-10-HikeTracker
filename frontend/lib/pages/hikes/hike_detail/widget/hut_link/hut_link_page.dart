import 'package:HikeTracker/common/city_input_field/models.dart';
import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/message.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/map_borders.dart';
import 'package:HikeTracker/models/map_data.dart';
import 'package:HikeTracker/pages/hikes/hike_detail/widget/hut_link/widget/hut_link.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class LinkHut extends StatefulWidget {
  const LinkHut({
    required this.client,
    required this.gpx,
    required this.hikeID,
    super.key,
  });

  final RestClient client;
  final String gpx;
  final int hikeID;

  @override
  State<LinkHut> createState() => _LinkHutState();
}

class _LinkHutState extends State<LinkHut> {
  bool isLoading = false;
  LatLng? selectedCoordinate;
  MapBorders? mapBorders;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : TwoColumnsLayout(
            isNested: !context.isMobile,
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
                        selected = true;
                      });
                    },
                    selectedCoordinates: selectedCoordinate != null
                        ? [selectedCoordinate!]
                        : null,
                    mapData: MapData.fromStringGPX(stringGpx: widget.gpx),
                  ),
                ),
              ],
            ),
            rightChild: HutLinkForm(
              onSubmit: (
                selectedHut,
              ) =>
                  onSubmit(
                selectedHut: selectedHut,
              ),
              client: widget.client,
              disabled: selected == false,
              longitude: selectedCoordinate?.longitude,
              latitude: selectedCoordinate?.latitude,
            ),
          );
  }

  Future<MapBorders> getBorders(City city) async {
    final res = await widget.client.get(api: 'border/${city.id}');
    return MapBorders.fromJson(res.body);
  }

  Future<void> onSubmit({
    required int? selectedHut,
  }) async {
    if (selectedCoordinate == null) {
      Message(
        context: context,
        message: 'Select the hut position from the map',
        messageType: MessageType.Error,
      ).show();
      return;
    }

    if (selectedHut == null) {
      Message(
        context: context,
        message: 'Select an hut',
      ).show();
      return;
    }

    final res = await widget.client.post(api: 'linkHut', body: {
      'hike_ID': widget.hikeID,
      'hut_ID': selectedHut,
      'ref_type': 'generic point',
    });

    if (res.statusCode == 201) {
      Message(
        context: context,
        message: 'Hut linked successfully.',
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
