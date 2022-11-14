import 'package:flutter/material.dart';
import 'package:frontend/pages/home/models/filter.dart';
import 'package:frontend/pages/home/widget/hike_card.dart';
import 'package:frontend/rest_client.dart';
import 'package:layout/layout.dart';

import 'models/hike.dart';

class HikesTable extends StatefulWidget {
  const HikesTable({super.key, required this.filter, required this.client});

  final Filter filter;
  final RestClient client;

  @override
  State<StatefulWidget> createState() => _HikesTableState();
}

class _HikesTableState extends State<HikesTable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.client.get(
        api: 'hike',
        filter: widget.filter,
      ),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          final hikes = Hikes.fromJson(snapshot.data!.body);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: context.breakpoint < LayoutBreakpoint.sm
                  ? 1
                  : context.breakpoint < LayoutBreakpoint.md
                      ? 2
                      : context.breakpoint < LayoutBreakpoint.lg
                          ? 3
                          : 4,
            ),
            itemCount: hikes.results?.length ?? 0,
            itemBuilder: (context, index) =>
                HikeCard(hike: hikes.results![index]),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
