import 'package:flutter/material.dart';
import 'package:frontend/pages/home/models/filter.dart';
import 'package:frontend/pages/home/widget/hike_card.dart';
import 'package:frontend/utils/rest_client.dart';
import 'package:go_router/go_router.dart';
import 'package:layout/layout.dart';

import '../models/hike.dart';

class HikesTable extends StatefulWidget {
  const HikesTable({
    required this.client,
    required this.filter,
    super.key,
  });

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
            padding: context.breakpoint < LayoutBreakpoint.md
                ? const EdgeInsets.symmetric(
                    vertical: 80.0,
                    horizontal: 16.0,
                  )
                : const EdgeInsets.symmetric(
                    vertical: 80.0,
                    horizontal: 64.0,
                  ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              crossAxisCount: context.breakpoint < LayoutBreakpoint.sm
                  ? 1
                  : context.breakpoint < LayoutBreakpoint.lg
                      ? 2
                      : 3,
            ),
            itemCount: hikes.results?.length ?? 0,
            itemBuilder: (context, index) => HikeCard(
              hike: hikes.results![index],
              onTap: () => {
                GoRouter.of(context).push(
                  '/hike/${hikes.results![index].id}',
                )
              },
            ),
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
