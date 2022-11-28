import 'package:HikeTracker/pages/add_hike/widget/map_banner.dart';
import 'package:HikeTracker/pages/add_parking/widget/add_parking_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:gpx/gpx.dart';
import 'package:layout/layout.dart';

import 'models/parking_controller.dart';

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
  String? gpxContent;
  Gpx? gpx;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Row(
            children: [
              MapBanner(
                gpx: gpx,
                onGpxLoaded: (val, text) => setState(() {
                  gpx = val;
                  gpxContent = text;
                }),
              ),
              AddParkingForm(
                onSubmit: (parking) => onSubmit(
                  parking: parking,
                ),
                isSmall: context.breakpoint <= LayoutBreakpoint.xs,
              ),
            ],
          );
  }

  Future<void> onSubmit({required Parking parking}) async {
    final res = await widget.client.post(
      api: 'parking',
      body: {
        "parking": {
          "name": parking.name?.text,
        }
      },
    );

    if (res.body == '"Incorrect"') {
      // TODO
    } else {
      // pop
    }
  }
}
