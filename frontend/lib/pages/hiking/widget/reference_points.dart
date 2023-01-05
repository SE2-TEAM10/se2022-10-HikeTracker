import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/hiking/models/reference_point.dart';
import 'package:HikeTracker/pages/hiking/widget/point_card.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RefPointTable extends StatefulWidget {
  const RefPointTable({
    required this.client,
    required this.hike,
    this.user,
    super.key,
  });

  final RestClient client;
  final User? user;
  final int hike;

  @override
  State<RefPointTable> createState() => _RefPointTableState();
}

class _RefPointTableState extends State<RefPointTable> {
  late Future<Response> future;

  @override
  void initState() {
    future = widget.client.get(
      api: 'getReferencePointByHike/${widget.hike}',
    );
    super.initState();
  }

  Future<void> onSubmit(
    int refID,
  ) async {
    final res = await widget.client.put(api: 'updateRefReached', body: {
      'hike_ID': widget.hike,
      'ref_ID': refID,
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
          return GridView.builder(
            padding: context.isMobile
                ? const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  )
                : const EdgeInsets.symmetric(
                    vertical: 80.0,
                    horizontal: 64.0,
                  ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              crossAxisCount: 1,
            ),
            itemCount: points.results?.length ?? 0,
            itemBuilder: (context, index) => PointCard(
              user: widget.user,
              point: points.results![index],
              onTap: onSubmit,
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
