import 'dart:convert';

import 'package:HikeTracker/common/map_banner.dart';
import 'package:HikeTracker/common/two_columns_layout.dart';
import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/models/map_data.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/hike_detail/widget/hike_detail.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        if (snapshot.hasData) {
          return HikeDetailContent(
            user: widget.user,
            client: widget.client,
            hike: Hike.fromJson(snapshot.data!.body),
            gpx: jsonDecode(snapshot.data!.body)['gpx'],
          );
        }
        return Container();
      },
    );
  }
}

class HikeDetailContent extends StatefulWidget {
  const HikeDetailContent({
    required this.client,
    required this.hike,
    required this.gpx,
    this.user,
    super.key,
  });

  final User? user;
  final RestClient client;
  final String gpx;
  final Hike hike;

  @override
  State<HikeDetailContent> createState() => _HikeDetailContentState();
}

class _HikeDetailContentState extends State<HikeDetailContent> {
  @override
  Widget build(BuildContext context) {
    return TwoColumnsLayout(
      leftChild: widget.user != null
          ? Expanded(
              flex: 2,
              child: MapBanner(
                client: widget.client,
                mapData: MapData.fromStringGPX(stringGpx: widget.gpx),
              ),
            )
          : Container(),
      rightChild: Expanded(
        flex: 3,
        child: Details(
          hike: widget.hike,
        ),
      ),
    );
  }
}
