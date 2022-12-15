import 'package:HikeTracker/models/user.dart';
import 'package:HikeTracker/pages/huts/models/filter.dart';
import 'package:HikeTracker/pages/huts/models/hut.dart';
import 'package:HikeTracker/pages/huts/widget/hut_card.dart';
import 'package:HikeTracker/utils/rest_client.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:layout/layout.dart';

class HutsTableController {
  Function(Filter)? onFilterChange;
}

class HutsTable extends StatefulWidget {
  const HutsTable({
    required this.client,
    required this.filter,
    required this.controller,
    this.user,
    super.key,
  });

  final Filter filter;
  final RestClient client;
  final User? user;
  final HutsTableController controller;

  @override
  State<StatefulWidget> createState() => _HutsTableState();
}

class _HutsTableState extends State<HutsTable> {
  late Future<Response> future;

  @override
  void initState() {
    future = widget.client.get(
      api: 'hutWithFilters',
      filter: widget.filter,
    );
    widget.controller.onFilterChange = (newFilter) {
      setState(() {
        future = widget.client.get(
          api: 'hutWithFilters',
          filter: widget.filter,
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
          final huts = Huts.fromJson(snapshot.data!.body);
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
            itemCount: huts.results?.length ?? 0,
            itemBuilder: (context, index) => HutCard(
              hut: huts.results![index],
              onTap: () => {
                GoRouter.of(context).push(
                  '/hike/${huts.results![index].id}',
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
