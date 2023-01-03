import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/completedHikes/models/hike.dart';
import 'package:HikeTracker/pages/completedHikes/widget/completed_hike_card.dart';
import 'package:HikeTracker/utils/layout_utils.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CompletedHikesTable extends StatefulWidget {
  const CompletedHikesTable({
    required this.client,
    this.user,
    super.key,
  });

  final RestClient client;
  final User? user;

  @override
  State<CompletedHikesTable> createState() => _CompletedHikesTableState();
}

class _CompletedHikesTableState extends State<CompletedHikesTable> {
  late Future<Response> future;

  @override
  void initState() {
    future = widget.client.get(
      api: 'completedHike',
    );
    super.initState();
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
          final hikes = Hikes.fromJson(snapshot.data!.body);
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
              crossAxisCount: context.isMobile
                  ? 1
                  : context.isLaptop
                      ? 2
                      : 3,
            ),
            itemCount: hikes.results?.length ?? 0,
            itemBuilder: (context, index) => CompletedHikeCard(
              user: widget.user,
              hike: hikes.results![index],
              onTap: () => {},
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
