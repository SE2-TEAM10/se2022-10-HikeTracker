import 'package:HikeTracker/pages/add_hike/models/location_controller.dart';
import 'package:HikeTracker/pages/add_hike/widget/add_hike_form.dart';
import 'package:HikeTracker/pages/add_hike/widget/map_banner.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:gpx/gpx.dart';
import 'package:layout/layout.dart';

class AddHike extends StatefulWidget {
  const AddHike({
    required this.client,
    super.key,
  });

  final RestClient client;

  @override
  State<AddHike> createState() => _AddHikeState();
}

class _AddHikeState extends State<AddHike> {
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
              AddHikeForm(
                onSubmit: (name, length, expected_time, difficulty, description,
                        start, end) =>
                    onSubmit(
                  name: name,
                  length: length,
                  expected_time: expected_time,
                  difficulty: difficulty,
                  description: description,
                  start: start,
                  end: end,
                ),
                isSmall: context.breakpoint <= LayoutBreakpoint.xs,
              ),
            ],
          );
  }

  Future<void> onSubmit({
    required String name,
    required String length,
    required String expected_time,
    required String difficulty,
    required String description,
    required Location start,
    required Location end,
  }) async {
    final res = await widget.client.post(
      api: 'hike',
      body: {
        'hike': {
          'name': name,
          'length': length,
          'expected_time': expected_time,
          'difficulty': difficulty,
          'description': description,
        },
        'startp': {
          'location_name': start.name?.text,
          'city': start.city?.text,
          'province': start.province?.text,
        },
        'endp': {
          'location_name': end.name?.text,
          'city': end.city?.text,
          'province': end.province?.text,
        },
        'gpx': gpxContent,
      },
    );

    if (res.body == '"Incorrect"') {
      // TODO
    } else {
      // pop
    }
  }
}
