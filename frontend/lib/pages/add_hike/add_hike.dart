import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/message.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/map_data.dart';
import 'package:HikeTracker/pages/add_hike/models/new_hike.dart';
import 'package:HikeTracker/pages/add_hike/widget/add_hike_form.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  MapData? mapData;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : TwoColumnsLayout(
            leftFlex: 2,
            rightFlex: 3,
            leftChild: MapBanner(
              client: widget.client,
              mapData: mapData,
              onGpxLoaded: (data) => setState(
                () => mapData = data,
              ),
              dense: context.isMobile,
            ),
            rightChild: AddHikeForm(
              onSubmit: (
                newHike,
              ) =>
                  onSubmit(
                newHike: newHike,
              ),
            ),
          );
  }

  Future<void> onSubmit({
    required NewHike newHike,
  }) async {
    if (mapData == null) {
      Message(
        context: context,
        message: 'Select a GPX file.',
      ).show();
      return;
    }
    newHike = newHike.copyWith(gpx: mapData!.content);
    if (newHike.isFull() == false) {
      Message(
        context: context,
        message: 'Fill all the fields',
      ).show();
      return;
    }

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
