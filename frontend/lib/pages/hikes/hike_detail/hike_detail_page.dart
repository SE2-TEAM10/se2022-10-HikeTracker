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
import 'package:latlong2/latlong.dart';

class HikeDetail extends StatefulWidget {
  const HikeDetail({
    required this.client,
    required this.hikeID,
    required this.onHikeStart,
    this.user,
    super.key,
  });

  final RestClient client;
  final int hikeID;
  final User? user;
  final Function onHikeStart;

  @override
  State<HikeDetail> createState() => _HikeDetailState();
}

class _HikeDetailState extends State<HikeDetail> {
  Reference? startingRef;
  Reference? endingRef;

  @override
  void initState() {
    loadReferences();
    super.initState();
  }

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
          onHikeStart: widget.onHikeStart,
          startingRef: startingRef,
          endingRef: endingRef,
        );
      },
    );
  }

  void loadReferences() {
    widget.client
        .get(
      api: 'linkHut/${widget.hikeID}',
    )
        .then((value) {
      final List<dynamic> res = jsonDecode(value.body);
      final start = res.firstWhere(
        (element) => element['ref_type'] == 'start',
        orElse: () => null,
      );
      final end = res.firstWhere(
        (element) => element['ref_type'] == 'end',
        orElse: () => null,
      );

      if (start != null) {
        setState(() {
          startingRef = Reference(
            name: start['name'],
            coordinates: LatLng(start['latitude'], start['longitude']),
          );
        });
      }
      if (end != null) {
        setState(() {
          endingRef = Reference(
            name: end['name'],
            coordinates: LatLng(end['latitude'], end['longitude']),
          );
        });
      }
    });

    widget.client
        .get(
      api: 'linkParking/${widget.hikeID}',
    )
        .then((value) {
      final List<dynamic> res = jsonDecode(value.body);
      final start = res.firstWhere(
        (element) => element['ref_type'] == 'start',
        orElse: () => null,
      );
      final end = res.firstWhere(
        (element) => element['ref_type'] == 'end',
        orElse: () => null,
      );

      if (start != null) {
        setState(() {
          startingRef = Reference(
            name: start['name'],
            coordinates: LatLng(start['latitude'], start['longitude']),
          );
        });
      }
      if (end != null) {
        setState(() {
          endingRef = Reference(
            name: end['name'],
            coordinates: LatLng(end['latitude'], end['longitude']),
          );
        });
      }
    });
  }
}

class HikeDetailContent extends StatelessWidget {
  const HikeDetailContent({
    required this.client,
    required this.hike,
    required this.gpx,
    required this.onHikeStart,
    this.startingRef,
    this.endingRef,
    this.user,
    super.key,
  });

  final User? user;
  final RestClient client;
  final String? gpx;
  final Hike? hike;
  final Function onHikeStart;
  final Reference? startingRef;
  final Reference? endingRef;

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
              refNearStartingPoint: startingRef,
              refNearEndingPoint: endingRef,
            )
          : Container(),
      rightChild: hike != null
          ? Details(
              hike: hike!,
              isMine: user?.ID == hike!.userId,
              client: client,
              user: user,
              gpx: gpx,
              onHikeStart: onHikeStart,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
