import 'package:HikeTracker/models/hike.dart';
import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/home/models/filter.dart';
import 'package:HikeTracker/pages/home/widget/hike_card.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:layout/layout.dart';

class HikesTableController {
  Function(Filter)? onFilterChange;
}

class HikesTable extends StatefulWidget {
  const HikesTable({
    required this.client,
    required this.filter,
    required this.controller,
    this.user,
    super.key,
  });

  final Filter filter;
  final RestClient client;
  final User? user;
  final HikesTableController controller;

  @override
  State<HikesTable> createState() => _HikesTableState();
}

class _HikesTableState extends State<HikesTable> {
  late Future<Response> future;

  @override
  void initState() {
    future = widget.client.get(
      api: 'hike',
      filter: widget.filter,
    );
    widget.controller.onFilterChange = (newFilter) {
      setState(() {
        future = widget.client.get(
          api: 'hike',
          filter: newFilter,
        );
      });
    };
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
            padding: context.breakpoint < LayoutBreakpoint.md
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
