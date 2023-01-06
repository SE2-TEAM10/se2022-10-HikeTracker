import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/hiking/models/reference_point.dart';
import 'package:HikeTracker/pages/hiking/widget/point_card.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RefPointTable extends StatefulWidget {
  const RefPointTable({
    required this.client,
    required this.hikeSchedule,
    required this.hikeID,
    this.user,
    super.key,
  });

  final RestClient client;
  final User? user;
  final int hikeSchedule;
  final int hikeID;

  @override
  State<RefPointTable> createState() => _RefPointTableState();
}

class _RefPointTableState extends State<RefPointTable> {
  late Future<Response> future;

  @override
  void initState() {
    future = widget.client.get(
      api: 'getReferencePointByHike/${widget.hikeID}',
    );
    super.initState();
  }

  Future<void> onSubmit(
    int refID,
  ) async {
    await widget.client.put(
      api: 'updateRefReached',
      body: {
        'hike_ID': widget.hikeID,
        'ref_ID': refID,
      },
    );
    setState(() {
      future = widget.client.get(
        api: 'getReferencePointByHike/${widget.hikeID}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          final points = ReferencePoints.fromJson(snapshot.data!.body);
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            itemCount: points.results?.length ?? 0,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(top: index == 0 ? 64 : 16.0),
              child: PointCard(
                user: widget.user,
                point: points.results![index],
                onTap: () => onSubmit.call(points.results![index].id),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        }
        return Container();
      },
    );
  }
}
