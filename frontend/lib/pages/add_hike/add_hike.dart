import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/message.dart';
import 'package:HikeTracker/pages/add_hike/models/new_hike.dart';
import 'package:HikeTracker/pages/add_hike/widget/add_hike_form.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                onSubmit: (
                  newHike,
                ) =>
                    onSubmit(
                  newHike: newHike,
                ),
                isSmall: context.breakpoint <= LayoutBreakpoint.xs,
              ),
            ],
          );
  }

  Future<void> onSubmit({
    required NewHike newHike,
  }) async {
    if (gpxContent == null) {
      Message(
        context: context,
        message: 'Select a GPX file.',
      ).show();
      return;
    }
    newHike = newHike.copyWith(gpx: gpxContent);

    final res = await widget.client.post(
      api: 'hike',
      body: newHike.toMap(),
    );

    if (res.statusCode == 201) {
      Message(
        context: context,
        message: 'Hike added successfully.',
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
