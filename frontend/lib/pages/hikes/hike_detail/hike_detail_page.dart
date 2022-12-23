import 'dart:convert';

import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/models/map_data.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/hikes/hike_detail/widget/hike_detail.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';

class HikeDetail extends StatefulWidget {
  const HikeDetail({
    required this.client,
    required this.hikeID,
    this.user,
    super.key,
  });

  final RestClient client;
  final int hikeID;
  final User? user;

  @override
  State<HikeDetail> createState() => _HikeDetailState();
}

class _HikeDetailState extends State<HikeDetail> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.client.get(
        api: 'hikesdetails/${widget.hikeID}',
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        return HikeDetailContent(
          user: widget.user,
          client: widget.client,
          hike: snapshot.hasData ? Hike.fromJson(snapshot.data!.body) : null,
          gpx: snapshot.hasData ? jsonDecode(snapshot.data!.body)['gpx'] : null,
        );
      },
    );
  }
}

class HikeDetailContent extends StatelessWidget {
  const HikeDetailContent({
    required this.client,
    required this.hike,
    required this.gpx,
    this.user,
    super.key,
  });

  final User? user;
  final RestClient client;
  final String? gpx;
  final Hike? hike;

  @override
  Widget build(BuildContext context) {
    return TwoColumnsLayout(
      isNested: !context.isMobile,
      hideLeftChild: user == null,
      leftFlex: 2,
      rightFlex: 3,
      leftChild: user != null
          ? MapBanner(
              client: client,
              mapData:
                  gpx != null ? MapData.fromStringGPX(stringGpx: gpx!) : null,
            )
          : Container(),
      rightChild: hike != null
          ? Details(
              hike: hike!,
              isMine: user?.ID == hike!.userId,
              client: client,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
